Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab2JGQAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:00:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59683 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2JGQAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:00:01 -0400
MIME-Version: 1.0
In-Reply-To: <20121006220421.47f5fd56@endymion.delvare>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121006220421.47f5fd56@endymion.delvare>
Date: Sun, 7 Oct 2012 18:00:00 +0200
Message-ID: <CAN+gG=HOz9DN+x7MQ8RTEKNcbRi9Zq15a7xs6BTCeg2XUj4DCQ@mail.gmail.com>
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification implementation
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

Thanks for the comments, the tests and the review. I'm going to try to
answer most of the remarks, so here is the first:

On Sat, Oct 6, 2012 at 10:04 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Benjamin,
>
[...]
>a
> ERROR: "hiddev_report_event" [drivers/i2c/i2c-hid.ko] undefined!
> ERROR: "hiddev_disconnect" [drivers/i2c/i2c-hid.ko] undefined!
> ERROR: "hiddev_connect" [drivers/i2c/i2c-hid.ko] undefined!
> ERROR: "hid_pidff_init" [drivers/i2c/i2c-hid.ko] undefined!
> make[1]: *** [__modpost] Erreur 1
> make: *** [modules] Erreur 2
>
> This is because these functions aren't exported and I tried to build
> i2c-hid as a module.BTW I see that these functions are part of the
> usbhid driver, which looks seriously wrong. If these functions are
> transport layer-independent, they should be moved to the hid-code or
> some sub-module. One should be able to enable HID-over-I2C without
> HID-over-USB.

It looks like I've been mislead by the generic names of these functions.
By looking at the code, it appears that I can not use them in their
current state as they are all usb related.
I think that it will need some work to refactor the general part of
hiddev so that I2C and bluetooth can use them. For the next version,
I'll just drop hiddev and pidff support.
I'm not sure we won't ever find a ff device connected through i2c, but
the hiddev support will surely be needed.

Cheers,
Benjamin

>
> --
> Jean Delvare
