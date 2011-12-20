Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1LTKNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:13:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33689 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1LTKM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:12:59 -0500
MIME-Version: 1.0
In-Reply-To: <201112151001.52761.oneukum@suse.de>
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org>
 <201112141222.41006.oneukum@suse.de> <CAGS+omB8kmALYg+m__WpiGzcpTdFEzHz1x3gFFkyqofpnANvNQ@mail.gmail.com>
 <201112151001.52761.oneukum@suse.de>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Tue, 20 Dec 2011 18:12:37 +0800
X-Google-Sender-Auth: YeL2BOLaI2hLnQ9_5mkIp0UQm9I
Message-ID: <CAGS+omCLU6FAxmT3+TgYf0b8YvgfbH9CL9M6WpZ0yNS01O5Hrw@mail.gmail.com>
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

On Thu, Dec 15, 2011 at 5:01 PM, Oliver Neukum <oneukum@suse.de> wrote:
>
> Am Donnerstag, 15. Dezember 2011, 07:43:09 schrieb Daniel Kurtz:
>
> Hi,
>
> > I'm sorry, I'm not seeing how using a workqueue to set the LEDs
> > changes anything with respect to how the driver deals with USB reset.
>
> You are unfortunately right. This means that the driver currently is already
> buggy.
>
> > With or without a workqueue, LED control urbs are being queued and/or
> > submitted asynchronously to reset.  AFAICT, the only thing that
> > changes here is exactly when __usbhid_submit_report() is called.  In
> > the original case, this happens directly in the input event handler.
> > In the workqueue case, it happens in a system worker thread some short
> > time after the input handler finishes.
>
> The current driver kills the ctrl URB in cease_io() which is not enough
> to prevent new IO.
>
> > Could you please be more specific about what this patch breaks and
> > perhaps give some guidance on how to fix it?
>
> It breaks nothing. It just continues a bug and I assumed it was not present.
> Basically the work queue must do nothing after pre_reset() and post_reset()
> ought to rerun the work in case some request came down during that time.

So, is this an Ack for this patchset?
Can we fix any existing races in later patches?

Regards,
-Daniel

>        Regards
>                Oliver
