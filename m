Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2HJFMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 01:12:37 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33376 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab2HJFMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 01:12:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120809193859.GD14429@xanatos>
References: <1344504711-10916-1-git-send-email-kengyu@canonical.com>
 <20120809142406.GC14429@xanatos> <CADXHx7ZbWPb1qLQcdquE9QTkGhOwR0ka1gX2m+o_Y68c9jqtog@mail.gmail.com>
 <20120809193859.GD14429@xanatos>
From: Keng-Yu Lin <kengyu@canonical.com>
Date: Fri, 10 Aug 2012 13:11:53 +0800
X-Google-Sender-Auth: 0J9-4XO9axmKhbFAr-GP5X-ZQsk
Message-ID: <CADXHx7bHugKwiOM9od8v6frHJWCYVa1Q=xw2f68rW+xxf52TJg@mail.gmail.com>
Subject: Re: [PATCH] Intel xhci: Only switch the switchable ports
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 3:38 AM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Fri, Aug 10, 2012 at 12:13:19AM +0800, Keng-Yu Lin wrote:
>> On Thu, Aug 9, 2012 at 10:24 PM, Sarah Sharp
>> <sarah.a.sharp@linux.intel.com> wrote:
>> > On Thu, Aug 09, 2012 at 05:31:51PM +0800, Keng-Yu Lin wrote:
>> >> With a previous patch to enable the EHCI/XHCI port switching, it switches
>> >> all the available ports.
>> >>
>> >> The assumption is not correct because the BIOS may expect some ports
>> >> not switchable by the OS.
>> >
>> > Why would the BIOS expect some ports to not be switchable?  I know that
>> > we internally at Intel had discussed some theoretical reasons why it
>> > might not be good to switch some ports, but when I presented the
>> > original patch with this same code in it to Linux USB mailing list, both
>> > Alan and Greg said, "Why not unconditionally switch ports?"  I had no
>> > good examples at the time.
>> >
>> > Is this causing issues with some particular BIOS?
>> >
>>
>> Yes, this is causing the internal webcam missing on the USB bus as I
>> observed on some HM70-based laptops.
>
> Does anything show up in dmesg when you turn on
> CONFIG_USB_XHCI_HCD_DEBUGGING?  It would be good to know if it is
> totally not electrically present, or if there's some sort of xHCI
> hardware or software issue that's preventing the webcam from being
> enumerated.
>

I will try to collect the log when I have the laptops handy.

>> The internal webcam is attached to one port that is controlled by the
>> xhci host.
>> But the other ports with the outer plugs work well after booting. I
>> cannot test the USB port of the internal webcam easily (without
>> tearing down the laptop :-/).
>>
>> I also tried some similar HM77-based models. HM77 has no this issue.
>> This could be some chipset mystery I am not aware now.
>
> Could be.  Can you use any SMBIOS information to change the port
> switchover only for those HM70-based laptops?  And is it a particular
> laptop vendor or all HM70 laptops?
>
> As Alan said, I would rather not trust the BIOS to provide the correct
> port mask.
>

Frankly, IMHO, I think the patch is not about to trust or not to trust
the BIOS. I think this patch just does what the registers are designed
to do.
What if there is a good BIOS claiming some ports not to be switchable
but kernel does so. Isn't it a bad kernel too? :-)

  cheers,
-kengyu
