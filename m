Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab0DKNie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 09:38:34 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:34234 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab0DKNic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 09:38:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH v6 7/8, needs improvement] hid: add suspend/resume hooks for hid drivers
Date: Sun, 11 Apr 2010 15:38:30 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
References: <20100324233707.7243b04d@neptune.home> <alpine.LNX.2.00.1003311415000.24576@pobox.suse.cz> <20100411130226.4086a92d@neptune.home>
In-Reply-To: <20100411130226.4086a92d@neptune.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004111538.31009.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. April 2010 13:02:26 schrieb Bruno Prémont:
> Where do I find the bluetooth HID bits? I've been searching through kernel
> sources (under drivers/) but did not find bluetooth code trying to
> register a HID device...

net/bluetooth/hidp/core.c

> Below an updated patch which also calls the hook for auto-suspend case.
> The patch compiles but I've not runtime-tested it yet (especially for
> the auto-suspend part, as I'm not sure what should trigger it).

Looks basically good.

> As far as I understand the code, in auto-suspend case if the driver
> sends commands to the device it will have to call usbhid_wait_io().
> Please correct me if I'm wrong!

No, only if it wants to know that the command has finished.
hid_submit_out() will queue IO in the autosuspended case
and schedule a resumption.

> @@ -629,6 +632,11 @@ struct hid_driver {
>         int (*input_mapped)(struct hid_device *hdev,
>                         struct hid_input *hidinput, struct hid_field *field,
>                         struct hid_usage *usage, unsigned long **bit, int *max);
> +#ifdef CONFIG_PM
> +       int (*suspend)(struct hid_device *hdev, int auto_suspend);

It would be better to pass the full message.

	Regards
		Oliver
