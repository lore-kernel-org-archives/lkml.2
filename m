Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab2BFSzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:55:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56341 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2BFSzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:55:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4HJH+3EQAWowyVxZFa5jVy1EOo=SoybJqqcjhVdo0nzw@mail.gmail.com>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
	<1328425088-6562-2-git-send-email-yinghai@kernel.org>
	<CAErSpo4HJH+3EQAWowyVxZFa5jVy1EOo=SoybJqqcjhVdo0nzw@mail.gmail.com>
Date: Mon, 6 Feb 2012 10:55:14 -0800
X-Google-Sender-Auth: KkdUYbwMVi50277nOpVas280vNA
Message-ID: <CAE9FiQXeRGXE2RCe5S1iOE=QY37wauM=WUevjXWkMqMOjV3t7A@mail.gmail.com>
Subject: Re: [PATCH 01/24] PCI: Add iobusn_resource
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
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

On Mon, Feb 6, 2012 at 10:48 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> +struct resource iobusn_resource = {
>> +       .name   = "PCI busn",
>> +       .start  = 0,
>> +       .end    = 0xffffff,
>> +       .flags  = IORESOURCE_BUS,
>> +};
>
> I'm not sure this should be global.  iomem_resource and
> ioport_resource *are* really global, because they refer to processor
> address space that is the same for everybody.  But PCI bus numbers are
> specific to PCI.  Some machines don't have PCI at all, and there are
> different bus architectures to which this doesn't apply.

that does not hurt them.

>
> The 0-0xffffff range is misleading because it includes both the domain
> and the bus number, and it's meaningless to allocate ranges that cross
> domain boundaries.  For example, [bus 0x0000f0-0x000120] includes bus
> numbers from domain 0000 and domain 0001, which doesn't make any sense
> because a bus can only be in one domain.

allocation code will make sure it will be cross the boundary for domain.

>
> I think it would make more sense to keep this bus number resource in a
> per-host bridge structure.  Then we wouldn't need to include the
> domain number at all because the host bridge determines the domain.

not sure. insert the all busn_res of all peer root buses into one
global iobusn_resource
looks more simple.

Yinghai
