Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab1E0CG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 22:06:26 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:17498 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1E0CGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 22:06:25 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-127.messagelabs.com!1306461984!20650072!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.31]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "w.sang@pengutronix.de" <w.sang@pengutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 May 2011 21:06:21 -0500
Subject: Problem with patch rtc: ep93xx: Initialize drvdata before
 registering device
Thread-Topic: Problem with patch rtc: ep93xx: Initialize drvdata before
 registering device
Thread-Index: AcwcEqypJIiesXsaTi27O7b24t5pZw==
Message-ID: <0D753D10438DA54287A00B027084269764D331A4BE@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4R26cXn018201

Wolfram,

I think there is a problem with your patch:

commit 92d921c5def1a7b1411bc54859c0771b2cf2c08d
rtc: ep93xx: Initialize drvdata before registering device

You are calling platform_set_drvdata() with rtc == NULL at best, it
could possibly also be garbage.  The rtc variable is allocated in
rtc_device_register().

A couple printk's prove this out:

ep93xx_rtc_probe: before platform_set_drvdata -> rtc:   (null)
ep93xx-rtc ep93xx-rtc: rtc core: registered ep93xx-rtc as rtc0
ep93xx_rtc_probe: after rtc_device_register -> rtc: c4789c00

Regards,
Hartleyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
