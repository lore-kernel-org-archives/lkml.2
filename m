Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab1KGOrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:47:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab1KGOrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:47:13 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [PATCH 3/3] HID: usbhid: defer LED setting to a workqueue
Date: Mon, 7 Nov 2011 15:48:04 +0100
User-Agent: KMail/1.13.5 (Linux/3.1.0-rc9-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: jkosina@suse.cz, bleung@chromium.org, stern@rowland.harvard.edu,
        olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <1320139547-7921-1-git-send-email-djkurtz@chromium.org> <1320139547-7921-4-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1320139547-7921-4-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111071548.04483.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 1. November 2011, 10:25:47 schrieb Daniel Kurtz:
> Defer LED setting action to a workqueue.
> This is more likely to perform all LED change events in a single URB.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/hid/hid-input.c       |   42 ++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/usbhid/hid-core.c |   43 +++++++++++++++++++++++++++++++---------
>  drivers/hid/usbhid/usbhid.h   |    2 +
>  include/linux/hid.h           |    2 +

> @@ -1292,6 +1314,7 @@ static void hid_cancel_delayed_stuff(struct usbhid_device *usbhid)
>  {
>  	del_timer_sync(&usbhid->io_retry);
>  	cancel_work_sync(&usbhid->reset_work);
> +	cancel_work_sync(&usbhid->led_work);
>  }

Hi,

this seems to introduce a race in usbhid_stop() which might fail to kill the urb
used to change the LEDs.

	Regards
		Oliver
