Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab2CMRNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:13:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48473 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266Ab2CMRNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:13:48 -0400
Date: Tue, 13 Mar 2012 10:13:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Ben Guthro <ben@guthro.net>
Subject: Re: Linux 3.2.11
Message-ID: <20120313171344.GB18203@kroah.com>
References: <20120313171333.GA18203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313171333.GA18203@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 1ddd6e9..4b76371 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 2
-SUBLEVEL = 10
+SUBLEVEL = 11
 EXTRAVERSION =
 NAME = Saber-toothed Squirrel
 
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 9302d21..61894fc 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -252,20 +252,6 @@ static int wm8994_suspend(struct device *dev)
 		break;
 	}
 
-	switch (wm8994->type) {
-	case WM1811:
-		ret = wm8994_reg_read(wm8994, WM8994_ANTIPOP_2);
-		if (ret < 0) {
-			dev_err(dev, "Failed to read jackdet: %d\n", ret);
-		} else if (ret & WM1811_JACKDET_MODE_MASK) {
-			dev_dbg(dev, "CODEC still active, ignoring suspend\n");
-			return 0;
-		}
-		break;
-	default:
-		break;
-	}
-
 	/* Disable LDO pulldowns while the device is suspended if we
 	 * don't know that something will be driving them. */
 	if (!wm8994->ldo_ena_always_driven)
