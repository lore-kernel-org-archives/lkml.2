Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1KYXiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 18:38:06 -0500
Received: from 4.mo1.mail-out.ovh.net ([46.105.76.26]:60633 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753797Ab1KYXiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 18:38:05 -0500
X-Greylist: delayed 1701 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Nov 2011 18:38:05 EST
Date: Sat, 26 Nov 2011 00:38:01 +0100
From: Marc Vertes <marc.vertes@sigfox.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH] watchdog: fix nowayout setting in s3c2410_wdt
Message-ID: <4ed026d9.TvJLr8ihQ2VtvqPD%marc.vertes@sigfox.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2799268644863133673
X-Ovh-Remote: 78.224.61.197 (lys31-1-78-224-61-197.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefiedrudefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgfgggtgfesthejredttdervdenucfhrhhomhepofgrrhgtucggvghrthgvshcuoehmrghrtgdrvhgvrhhtvghssehsihhgfhhogidrtghomheqnecuffhomhgrihhnpeen
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -120
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrtddtucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnehlihhnuhigvdigucdlqddvtddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set nowayout flag in probe function, otherwise option is useless.

Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
---

 s3c2410_wdt.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-3.2-rc3/drivers/watchdog/s3c2410_wdt.c.orig	2011-11-24 05:20:28.000000000 +0100
+++ linux-3.2-rc3/drivers/watchdog/s3c2410_wdt.c	2011-11-26 00:08:58.985896169 +0100
@@ -395,6 +395,9 @@ static int __devinit s3c2410wdt_probe(st
 		s3c2410wdt_stop(&s3c2410_wdd);
 	}
 
+	if (nowayout)
+		set_bit(WDOG_NO_WAY_OUT, &s3c2410_wdd.status);
+
 	/* print out a statement of readiness */
 
 	wtcon = readl(wdt_base + S3C2410_WTCON);
