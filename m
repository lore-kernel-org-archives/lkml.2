Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0G2UlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:41:07 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:35844 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753389Ab0G2UlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:41:04 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] cyber2000fb: fix console in truecolor modes
Date: Thu, 29 Jul 2010 22:40:54 +0200
User-Agent: KMail/1.9.10
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201007282159.19583.linux@rainbow-software.org>
In-Reply-To: <201007282159.19583.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007292240.55525.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value was not set to 0 in setcolreg() with truecolor modes. This causes
fb_set_cmap() to abort after first color, resulting in blank palette - and
blank console in 24bpp and 32bpp modes.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.35-rc3-/drivers/video/cyber2000fb.c	2010-07-29 22:27:28.000000000 +0200
+++ linux-2.6.35-rc3/drivers/video/cyber2000fb.c	2010-07-29 22:29:04.000000000 +0200
@@ -392,6 +392,7 @@ cyber2000fb_setcolreg(u_int regno, u_int
 		pseudo_val |= convert_bitfield(red, &var->red);
 		pseudo_val |= convert_bitfield(green, &var->green);
 		pseudo_val |= convert_bitfield(blue, &var->blue);
+		ret = 0;
 		break;
 	}
 


-- 
Ondrej Zary
