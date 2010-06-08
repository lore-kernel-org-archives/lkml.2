Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0FHDLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:11:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36358 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0FHDLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:11:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=a9yQpRPuzEDLlrTua18pyyUGHYPMtBU03o03Qle1N5kxQH9Zsf8Tq8kVTrUlDOh/uP
         ywXZLr7ho6tqBdTZ2ovdWlRvaw3Iwc8sspPyD9iLbrQstV3/FI3VDgAku0aIeVDeIdLr
         l13mTK1NznoqFvY6Z/olPeNexLZecXryuD2TE=
MIME-Version: 1.0
Date: Tue, 8 Jun 2010 12:11:44 +0900
Message-ID: <AANLkTilDZdke5V6TYtDheK9rCaxTDHqtoPR7I_tEvFR2@mail.gmail.com>
Subject: setting miscdevice.parent after misc_register()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/watchdog/at32ap700x_wdt.c, and drivers/watchdog/sch311x_wdt.c
miscdevice.parent is set after misc_register().

drivers/watchdog/at32ap700x_wdt.c:

	ret = misc_register(&wdt->miscdev);
	...
	wdt->miscdev.parent = &pdev->dev;

But it does nothing. (the miscdevice will not be a child of that parent
device in sysfs)

So should it be set before misc_register() or just keep it as-is?
