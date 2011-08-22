Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1HVSL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:11:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45719 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1HVSL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110822155529.GA4783@xanatos>
References: <CA+OjSzyMGBsjCmwAgrFDkX3uphD9ya8DBGQw1nVktoKX=wpDHQ@mail.gmail.com>
	<20110822155529.GA4783@xanatos>
Date: Mon, 22 Aug 2011 23:41:53 +0530
Message-ID: <CAFPAmTSx1d=A5r-6FR9=pcm-8eKer_+=5Bu_sevfs_Ni+cSxag@mail.gmail.com>
Subject: Re: [PATCH] xhci: Redundant check for
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: sifram rajas <sifram.rajas@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for replying back.

Really sorry about your email address, Sarah.

I think it was a typo. Ill take of emailing you at
sarah.a.sharp@linux.intel.com in future, starting from this email.

Regards,
Kautuk.


On Mon, Aug 22, 2011 at 9:25 PM, Sarah Sharp <sarah.a.sharp@intel.com> wrote:
> Hi Sifram,
>
>
> On Mon, Aug 22, 2011 at 08:35:20AM -0700, sifram rajas wrote:
>> Hi Sarah,
>>
>> This patch is for linux-3.0.3.
>>
>> In the xhci_check_args() function in xhci.c, there is a redundant
>> check for xhci->devs.
>>
>> This is redundant because the struct xhci_hcd->devs is actually
>> defined as a static array
>> of pointers and is not a pointer to a pointer.
>
> Your patch looks fine, and I'll apply it to my usb-next branch later
> this week.
>
> However, can you please send future patches to
> sarah.a.sharp@linux.intel.com, not my intel.com address?  The intel.com
> one runs through a horrible exchange server that converts tabs to spaces
> and makes it impossible to apply patches.
>
> Where did you find the intel.com email address?  I'm pretty sure the
> MAINTAINERS file lists the linux.intel.com one, and I'd like to make
> sure people aren't getting bad information.
>
> Sarah Sharp
>
>> Signed-off-by: Sifram Rajas <sifram.rajas@gmail.com>
>> ---
>> drivers/usb/host/xhci.c |   3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>> --- a/drivers/usb/host/xhci.c 2011-08-17 23:27:16.000000000 +0530
>> +++ b/drivers/usb/host/xhci.c 2011-08-22 20:43:34.250000000 +0530
>> @@ -945,8 +945,7 @@ static int xhci_check_args(struct usb_hc
>>               return -ENODEV;
>>
>>       if (check_virt_dev) {
>> -             if (!udev->slot_id || !xhci->devs
>> -                     || !xhci->devs[udev->slot_id]) {
>> +             if (!udev->slot_id || !xhci->devs[udev->slot_id]) {
>>                       printk(KERN_DEBUG "xHCI %s called with unaddressed "
>>                                               "device\n", func);
>>                       return -EINVAL;
>>
>> Thanks,
>> Sifram Rajas.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
