Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1KYXUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 18:20:49 -0500
Received: from 7.mo1.mail-out.ovh.net ([87.98.158.110]:47532 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751371Ab1KYXUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 18:20:48 -0500
Date: Fri, 25 Nov 2011 23:55:28 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH] watchdog: fix nowayout setting in wm831x_wdt
Message-ID: <4ed01ce0.pLO/jX2YTtsMsYc8%marc.vertes@sigfox.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2080663028750599983
X-Ovh-Remote: 78.224.61.197 (lys31-1-78-224-61-197.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrudefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfgggtgfgsehtjeertddtredvnecuhfhrohhmpeforghrtgcugggvrhhtvghsuceomhgrrhgtrdhvvghrthgvshesshhighhfohigrdgtohhmqeenucffohhmrghinhepne
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -20
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrtddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenuchlihhnuhigvdigucdlqddvtddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use set_bit() to set the nowayout flag, as WDOG_NO_WAY_OUT is a
bit number, not a mask. It avoids corruption of status flag.

Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
---

 wm831x_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.2-rc3/drivers/watchdog/wm831x_wdt.c.orig	2011-11-24 05:20:28.000000000 +0100
+++ linux-3.2-rc3/drivers/watchdog/wm831x_wdt.c	2011-11-25 23:22:22.447258730 +0100
@@ -216,7 +216,7 @@ static int __devinit wm831x_wdt_probe(st
 	watchdog_set_drvdata(wm831x_wdt, driver_data);
 
 	if (nowayout)
-		wm831x_wdt->status |= WDOG_NO_WAY_OUT;
+		setbit(WDOG_NO_WAY_OUT, &wm831x_wdt->status);
 
 	reg = wm831x_reg_read(wm831x, WM831X_WATCHDOG);
 	reg &= WM831X_WDOG_TO_MASK;
