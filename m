Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab2BJXkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:40:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42624 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab2BJXky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 18:40:54 -0500
MIME-Version: 1.0
In-Reply-To: <20120210125150.3353237c@jbarnes-desktop>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
	<1328425088-6562-2-git-send-email-yinghai@kernel.org>
	<CAErSpo4HJH+3EQAWowyVxZFa5jVy1EOo=SoybJqqcjhVdo0nzw@mail.gmail.com>
	<CAE9FiQXeRGXE2RCe5S1iOE=QY37wauM=WUevjXWkMqMOjV3t7A@mail.gmail.com>
	<20120210125150.3353237c@jbarnes-desktop>
Date: Fri, 10 Feb 2012 15:40:53 -0800
X-Google-Sender-Auth: iwkLtEfqRmPf2qI30xg0axcb790
Message-ID: <CAE9FiQXvzHM4a=u5PDbRkKEo5EC8c7VaZZgQ8wyTjveegf=7dA@mail.gmail.com>
Subject: Re: [PATCH 01/24] PCI: Add iobusn_resource
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 12:51 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Mon, 6 Feb 2012 10:55:14 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On Mon, Feb 6, 2012 at 10:48 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> >> +struct resource iobusn_resource = {
>> >> +       .name   = "PCI busn",
>> >> +       .start  = 0,
>> >> +       .end    = 0xffffff,
>> >> +       .flags  = IORESOURCE_BUS,
>> >> +};
>> >
>> > I'm not sure this should be global.  iomem_resource and
>> > ioport_resource *are* really global, because they refer to processor
>> > address space that is the same for everybody.  But PCI bus numbers are
>> > specific to PCI.  Some machines don't have PCI at all, and there are
>> > different bus architectures to which this doesn't apply.
>>
>> that does not hurt them.
>
> Yes but it's superfluous and confusing if you're porting to a new arch
> or looking at changes in generic code that may affect you.
>
>> > The 0-0xffffff range is misleading because it includes both the domain
>> > and the bus number, and it's meaningless to allocate ranges that cross
>> > domain boundaries.  For example, [bus 0x0000f0-0x000120] includes bus
>> > numbers from domain 0000 and domain 0001, which doesn't make any sense
>> > because a bus can only be in one domain.
>>
>> allocation code will make sure it will be cross the boundary for domain.
>
> But that means everyone reading it will do a double take, have to dig
> into the implementation, and only then say "ah yeah ok it looks
> correct" rather than it being obvious from the fact that the resource
> is tracked on a per-domain basis.
>
>> > I think it would make more sense to keep this bus number resource in a
>> > per-host bridge structure.  Then we wouldn't need to include the
>> > domain number at all because the host bridge determines the domain.
>>
>> not sure. insert the all busn_res of all peer root buses into one
>> global iobusn_resource
>> looks more simple.
>
> In what sense?  Simpler in the sense of your current implementation,
> but not simpler at all to someone just reading the code...

ok, will check if i could drop iobusn_resource.

Yinghai
