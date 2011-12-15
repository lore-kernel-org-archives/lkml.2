Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1LOGnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:43:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65057 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab1LOGnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:43:32 -0500
MIME-Version: 1.0
In-Reply-To: <201112141222.41006.oneukum@suse.de>
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org>
 <201112140901.35203.oneukum@suse.de> <CAGS+omA=9qfqDYtaLp67Xz+WhcpW_=jn9hoiaad43Z+oexjsFQ@mail.gmail.com>
 <201112141222.41006.oneukum@suse.de>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 15 Dec 2011 14:43:09 +0800
X-Google-Sender-Auth: ubN5qlzETGXLRK2qSAp4sRHN3HM
Message-ID: <CAGS+omB8kmALYg+m__WpiGzcpTdFEzHz1x3gFFkyqofpnANvNQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] HID: usbhid: defer LED setting to a workqueue
To: Oliver Neukum <oneukum@suse.de>
Cc: jkosina@suse.cz, bleung@chromium.org, stern@rowland.harvard.edu,
        olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 7:22 PM, Oliver Neukum <oneukum@suse.de> wrote:
> Am Mittwoch, 14. Dezember 2011, 11:33:03 schrieb Daniel Kurtz:
>> On Wed, Dec 14, 2011 at 4:01 PM, Oliver Neukum <oneukum@suse.de> wrote:
>> > Am Donnerstag, 17. November 2011, 12:23:50 schrieb Daniel Kurtz:
>> >> Defer LED setting action to a workqueue.
>> >> This is more likely to send all LED change events in a single URB.
>> >
>> > Hi,
>> >
>> > I hope I am looking at the correct version of this patch.
>> > But as far as I can see the work for handling LEDs is not delayed
>> > while a reset is going on. That is wrong.
>>
>> Actually, I'm not sure why this is wrong.  I find the reset handling
>> quite confusing in this driver.
>> Can you point out what will fail, and recommend how to fix it?
>
> That is part of the workings of a USB driver. After you return from
> pre_reset() you don't do IO to the device. After post_reset() the
> device should be in its default state whose LED states won't match
> what they ought to be.

Hi Oliver,

I'm sorry, I'm not seeing how using a workqueue to set the LEDs
changes anything with respect to how the driver deals with USB reset.

With or without a workqueue, LED control urbs are being queued and/or
submitted asynchronously to reset.  AFAICT, the only thing that
changes here is exactly when __usbhid_submit_report() is called.  In
the original case, this happens directly in the input event handler.
In the workqueue case, it happens in a system worker thread some short
time after the input handler finishes.

Could you please be more specific about what this patch breaks and
perhaps give some guidance on how to fix it?

Thanks and Best Regards,
-Daniel

>
>        Regards
>                Oliver
