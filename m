Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1FIWsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:48:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47119 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab1FIWs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=k/YEsaMhQo/vuTLNiBY4a3DLhwAGKh6kkzAiGOUXmMZ+82ru5vKQGHyuk06I2K0Uun
         5kp/L0GgSMIKh90lX6Wky+QSuXFws53l2B+YyiOHLioGM9K5ZQwwpijqA7sKwyjNgPL9
         3GNUCtgiDZarugSnkwlcsSoXz+MyVJ8VuPEQ8=
Date: Thu, 9 Jun 2011 18:19:12 -0400
From: Jay Estabrook <jay.estabrook@gmail.com>
To: linux-alpha <linux-alpha@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Cc: Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Jay Estabrook <jay.estabrook@gmail.com>, airlied@linux.ie
Subject: [PATCH 2/3] alpha, drm: Remove obsolete Alpha support in MGA DRM
 code
Message-ID: <20110609181912.2dfad4fe.jay.estabrook_gmail.com@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; alpha-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove an obsolete Alpha adjustment in the drm for MGA on Alpha.

Signed-off-by: Jay Estabrook <jay.estabrook@gmail.com>
---
 drivers/gpu/drm/mga/mga_drv.h |   19 -------------------
 1 file changed, 19 deletions(-)

diff -Naurp a/drivers/gpu/drm/mga/mga_drv.h b/drivers/gpu/drm/mga/mga_drv.h
--- a/drivers/gpu/drm/mga/mga_drv.h	2011-04-26 23:48:50.000000000 -0400
+++ b/drivers/gpu/drm/mga/mga_drv.h	2011-05-02 11:51:48.000000000 -0400
@@ -195,29 +195,10 @@ extern long mga_compat_ioctl(struct file
 
 #define mga_flush_write_combine()	DRM_WRITEMEMORYBARRIER()
 
-#if defined(__linux__) && defined(__alpha__)
-#define MGA_BASE(reg)		((unsigned long)(dev_priv->mmio->handle))
-#define MGA_ADDR(reg)		(MGA_BASE(reg) + reg)
-
-#define MGA_DEREF(reg)		(*(volatile u32 *)MGA_ADDR(reg))
-#define MGA_DEREF8(reg)		(*(volatile u8 *)MGA_ADDR(reg))
-
-#define MGA_READ(reg)		(_MGA_READ((u32 *)MGA_ADDR(reg)))
-#define MGA_READ8(reg)		(_MGA_READ((u8 *)MGA_ADDR(reg)))
-#define MGA_WRITE(reg, val)	do { DRM_WRITEMEMORYBARRIER(); MGA_DEREF(reg) = val; } while (0)
-#define MGA_WRITE8(reg, val)	do { DRM_WRITEMEMORYBARRIER(); MGA_DEREF8(reg) = val; } while (0)
-
-static inline u32 _MGA_READ(u32 *addr)
-{
-	DRM_MEMORYBARRIER();
-	return *(volatile u32 *)addr;
-}
-#else
 #define MGA_READ8(reg)		DRM_READ8(dev_priv->mmio, (reg))
 #define MGA_READ(reg)		DRM_READ32(dev_priv->mmio, (reg))
 #define MGA_WRITE8(reg, val)	DRM_WRITE8(dev_priv->mmio, (reg), (val))
 #define MGA_WRITE(reg, val)	DRM_WRITE32(dev_priv->mmio, (reg), (val))
-#endif
 
 #define DWGREG0		0x1c00
 #define DWGREG0_END	0x1dff

---
