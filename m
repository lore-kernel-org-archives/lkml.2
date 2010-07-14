Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab0GNPFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:05:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab0GNPFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CEWo4oKC9HELT4A3ttaXlzGENF6Znd0YL4ebBZdUr5BCq1BNEalykUfj7u+t0oXu75
         1hRpHUXopC0vKEKAbxUFgLGTOG2+yygJsPqjL6kjN+GBOnaYJpWUz8xkiwxPrYU45hIc
         PvYxf6mLXqHiIJ/RfcJNCIE0GNrqsC3ABJsQg=
MIME-Version: 1.0
In-Reply-To: <op.vft7mxqm7p4s8u@pikus>
References: <Pine.LNX.4.44L0.1007131003560.1568-100000@iolanthe.rowland.org>
	<1279098331-7872-1-git-send-email-ext-andriy.shevchenko@nokia.com>
	<op.vft2p6do7p4s8u@pikus>
	<AANLkTil1eG5yzBxvryf-TZINYjeGph-rNz8eELQtm5tj@mail.gmail.com>
	<op.vft7mxqm7p4s8u@pikus>
Date: Wed, 14 Jul 2010 18:05:07 +0300
Message-ID: <AANLkTilnIRCgyiSbLVbPubU38CSLwVan17GAHqNMX1Ir@mail.gmail.com>
Subject: Re: [PATCHv2] usb: gadget: storage: optional SCSI WRITE FUA bit
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: =?UTF-8?Q?Micha=C5=82_Nazarewicz?= <m.nazarewicz@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/14 Michał Nazarewicz <m.nazarewicz@samsung.com>:
> On Wed, 14 Jul 2010 15:44:58 +0200, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>>>> + *     fua=b[,b...]            Default false, booleans for ignore FUA
>>>> flag
>>>> + *                                     in SCSI WRITE(6,10,12) commands
>>>
>>> I wonder if it makes sense to make it per-LUN.  I would imagine
>>> that it's great to ignore FUA if the device has its own power supply
>>> in which case after disconnect the data won't be lost.  This is a
>>> per-device property not really per-LUN.  As such I'd make this option
>>> global for the gadget.
>
>> Make sense only for removable media with one partition.
>> Otherwise. why we have sync option per partition f.e., not per device?
>
> Ah, OK, I see why this is per LUN.  You want to be able not to ignore
> FUA if the backing storage is a removable media, right?
In instance, or vise versa.
So, the user could decide if he wants to avoid this flag for one LUN
or for another.

>>>> +       if (sscanf(buf, "%d", &i) != 1)
>>>> +               return -EINVAL;
>>> Why not simple_strtol() directly?
>> I did it in the same way like fsg_store_ro() does.
>> I have no objections to back to previous solution.
> OK.  I'd use simpre_strol() myself.  Maybe even patched fsg_store_ro().
Agree, but better to do series of patches then, I guess.

>>>> +
>>>> +       if (curlun->fua)
>>>> +               fsg_lun_fsync_sub(curlun);
>
>>> Shouldn't that read something like:
>>>
>>> +       if (!curlun->fua && i)
>>> +               fsg_lun_fsync_sub(curlun);
>>>
>>> ie. there is no sense in syncing if FUA was active (in which case all
>>> writes were synced already, right?) or if the new value is false (since
>>> then user does not won't syncing).
>
>> The idea is to sync data before switching from async mode.
>
> But there can be a case of switching from async to async when syncing
> is not necessary.  That's why I proposed the &&.  With fua = 1 meaning
> ignore the flag my proposal would be:
>
> +       if (!i && curlun->fua)
> +               fsg_lun_fsync_sub(curlun);
Makes sense.

>> Actually fua = 1 means ignorance of that flag.
> ignore_fua would be better name then I think.  This also stands for
> module parameter.
I already thought about. Rather I agree with you.


-- 
With Best Regards,
Andy Shevchenko
