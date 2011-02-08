Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab1BHUDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:03:32 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63987 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab1BHUD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:03:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=RTNAPdwL+n6ZWotWRjDTzFdoOdMRXbGKVsgdDoTNcMM7WKf9pwvw6dUIVZ5xIu2gtd
         1M8uD/U68+/V054uMiZ8fttWEQds2KO3ahxjA4lfFIHktdDWtDCkCE4nm6MNxBT/tJXV
         gOalHHAAH5b/3ZW5eA+GdPRvbefc1gg1P1cDw=
MIME-Version: 1.0
Date: Tue, 8 Feb 2011 21:03:27 +0100
X-Google-Sender-Auth: 9OuYGz9D4oRMVcQyBonV22rqBRc
Message-ID: <AANLkTim2706Negrvd-ektbNMLwucM9M0icphb_uFY_9D@mail.gmail.com>
Subject: drivers/input/touchscreen/ads7846.c:959: error: 'GPIOF_DIR_IN' undeclared
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sourav Poddar <sourav.poddar@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: Linux-Next <linux-next@vger.kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-next/m68k-allmodconfig/m68k:
http://kisskb.ellerman.id.au/kisskb/buildresult/3899710/

drivers/input/touchscreen/ads7846.c:959: error: 'GPIOF_DIR_IN'
undeclared (first use in this function)
drivers/input/touchscreen/ads7846.c:959: error: (Each undeclared
identifier is reported only once
drivers/input/touchscreen/ads7846.c:959: error: for each function it
appears in.)
make[4]: *** [drivers/input/touchscreen/ads7846.o] Error 1

As of commit e9b6e245c727767e6d64cb3dd47a0c6982aa5d23
("Input: ads7846 - use gpio_request_one to configure pendown_gpio"), this
driver should depend on GENERIC_GPIO?
Else <linux/gpio.h> doesn't include <asm/gpio.h>, and we never see the
definition of GPIOF_DIR_IN.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
