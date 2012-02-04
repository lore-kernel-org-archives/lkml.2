Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2BDCaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 21:30:46 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35855 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2BDCao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 21:30:44 -0500
MIME-Version: 1.0
In-Reply-To: <1328312292.30631.5.camel@pasglop>
References: <1328136242-17725-1-git-send-email-yinghai@kernel.org>
	<1328136242-17725-3-git-send-email-yinghai@kernel.org>
	<CAErSpo44bef-Vj4LPB0QJ8HRjWxqRFK_=kpMq8hYEe=4t58zGQ@mail.gmail.com>
	<1328312292.30631.5.camel@pasglop>
Date: Fri, 3 Feb 2012 18:30:42 -0800
X-Google-Sender-Auth: gNTdcMCTShULGG2U6DJBlFi5UL4
Message-ID: <CAE9FiQVG9YbZW=Usv0drxuyQ=ZTERK5KZK3TF6aX-iWuAS8L6Q@mail.gmail.com>
Subject: Re: [PATCH 02/15] PCI: Add iobusn_resource
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 3:38 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2012-02-03 at 08:36 -0800, Bjorn Helgaas wrote:
>> On Wed, Feb 1, 2012 at 2:43 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > also add busn_res into struct pci_bus.
>> >
>> > will use them to have bus number resource tree.
>>
>> Will you make this tree visible in /proc?  Seems like that would be
>> useful for debugging and for symmetry with /proc/iomem and
>> /proc/ioports.
>
> To be honest that whole business with bus numbers in struct resource
> seems like gratuituous bloat & over engineering to me ...

ah, i thought it is simple enough, and should be done before already.

> Does it actually solve a specific problem or serve a purpose ?

very beginning is for one IBM x3950...

https://bugzilla.novell.com/show_bug.cgi?id=735909

++max searching valid bus number range is out of boundary of peer root
bus range.

later, found the code could help: pcie hotplug, pci bus rescan and
even remove some hacks for/from cardbus field.

now with this patchset (+ one patch that is not sent out yet), I could
even use setpci/pci rescan to move pci bus around.

Thanks

Yinghai
