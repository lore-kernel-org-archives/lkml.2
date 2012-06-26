Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2FZJS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:18:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40867 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2FZJS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:18:26 -0400
MIME-Version: 1.0
Date: Tue, 26 Jun 2012 14:48:26 +0530
Message-ID: <CAHdPZaMo6P-OA84NAGyXRArm1Hjc9xvo1zAMiG2N-w3me8RnWQ@mail.gmail.com>
Subject: watchdog: del_timer call missing on the cpu5wdt.c
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We do a setup_timer at init stage of the module, but we didn't
de-activate the time using del_timer.

The below patch may help doing so..

Please feel free to comment...



diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 7e88839..fca50a7 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -266,6 +266,7 @@ static void __devexit cpu5wdt_exit(void)
        if (cpu5wdt_device.queue) {
                cpu5wdt_device.queue = 0;
                wait_for_completion(&cpu5wdt_device.stop);
+               del_timer(&cpu5wdt_device.timer);
        }


Thanks,
Devendra.
