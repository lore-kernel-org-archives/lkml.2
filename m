Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1EEHy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 03:54:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61031 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1EEHy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 03:54:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=GZcysqFEosOgbW1sZw+2ohsxYH2XZ/NmLOxRgGQLWMpZT/JLWFceaoH9GrqGs5lvKd
         IPX79ouYMcrk7ZkzawmLk3wl320Xkcfvs39Tjtd1NSv9+R410V5A+8/83jHMY5k3cyxf
         j08AOI3nQHILF3S3jouCpA07+wHDCeXvcm1i8=
Message-ID: <4DC257AE.2010502@gmail.com>
Date: Thu, 05 May 2011 15:54:22 +0800
From: microcai <microcaicai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110504 Thunderbird/3.1.10
MIME-Version: 1.0
To: arnaud.patard@rtp-net.org, ben@simtec.co.uk
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][INPUT]s3c2410_ts.c add report for ABS_PRESSURE, this fix
 tslib problem that not, been able to detect pen-down and pen-up events.
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Heya,

I'm not sure if this works for every SoC, but works for my machine.
The tslib was never never able to detect pen-down and pen-up event even
the driver does report BT_TOUCH up and down, I figure out that what
it need is actually ABS_PRESSURE.

Spend days and night debug tslib, but amazing that it's the driver
that case the problem.

I've see the log,

   - remove ABS_PRESSURE reporting, tslib can be fixed

It was removed once, so, I'm not sure if my patch fits for all, or
just my ugly hardware?


- From 995fbed3a4b0a913916b96eef907abe47fec3f91 Mon Sep 17 00:00:00 2001
From: microcai <microcai@fedoraproject.org>
Date: Thu, 5 May 2011 14:40:44 +0800
Subject: [PATCH] add report for ABS_PRESSURE, this fix tslib problem
that not
 been able to detect pen-down and pen-up events.

- ---
 drivers/input/touchscreen/s3c2410_ts.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/s3c2410_ts.c
b/drivers/input/touchscreen/s3c2410_ts.c
index 8feb7f3..ecab5d4 100644
- --- a/drivers/input/touchscreen/s3c2410_ts.c
+++ b/drivers/input/touchscreen/s3c2410_ts.c
@@ -126,6 +126,7 @@ static void touch_timer_fire(unsigned long data)
 			input_report_abs(ts.input, ABS_Y, ts.yp);

 			input_report_key(ts.input, BTN_TOUCH, 1);
+			input_report_abs(ts.input, ABS_PRESSURE, 1);
 			input_sync(ts.input);

 			ts.xp = 0;
@@ -140,6 +141,7 @@ static void touch_timer_fire(unsigned long data)
 		ts.count = 0;

 		input_report_key(ts.input, BTN_TOUCH, 0);
+		input_report_abs(ts.input, ABS_PRESSURE, 0);
 		input_sync(ts.input);

 		writel(WAIT4INT | INT_DOWN, ts.io + S3C2410_ADCTSC);
@@ -318,6 +320,7 @@ static int __devinit s3c2410ts_probe(struct
platform_device *pdev)
 	ts.input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 	input_set_abs_params(ts.input, ABS_X, 0, 0x3FF, 0, 0);
 	input_set_abs_params(ts.input, ABS_Y, 0, 0x3FF, 0, 0);
+	input_set_abs_params(ts.input, ABS_PRESSURE, 0, 1, 0, 0);

 	ts.input->name = "S3C24XX TouchScreen";
 	ts.input->id.bustype = BUS_HOST;
- -- 
1.7.5.rc3


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQEcBAEBAgAGBQJNwlesAAoJEKT4Uz7oTANZtY0IAJl4kK3fuApKja/k2gzaE5Py
7JP4oPxgmepbM8HK8JvQUhPLiWWKu1eZYkSAPJ1L95HeswYTIp4/iC8Ut+ieF4pq
+6tPd+ZcJlamTo9IZa1OwDCOOezgEUhP/aB7N9z+ARbVQaCqIBvEr9g2DVyPIXFb
B2xVfPZjnFwJAKuHZjpVn8ncN0LcpTgNU7W0o3z8YQw91Tjc9v+V58xE2xwzlpRi
wvovCpL3AAQ+uYXWLa5ChGU+xdAlJ7GyFQwzICleaSlxAgbF+USJlgkMO6pYlx7P
kdF2j3m01WYA82nKZH1kOpkX2vl1lZQMiOIVVoU8YC8huu5ty06Tr7UIEb5ar8I=
=NvuY
-----END PGP SIGNATURE-----
