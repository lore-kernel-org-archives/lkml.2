Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2ILXiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:38:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab2ILXiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:38:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Heiko Stuebner <heiko@sntech.de>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 09/85] ARM: S3C24XX: Add missing DMACH_DT_PROP
Date: Wed, 12 Sep 2012 16:35:52 -0700
Message-Id: <20120912233542.705358272@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

commit e1267371eacf2cbcf580e41f9e64a986cdaf5c1d upstream.

Commit 2b90807549 (spi: s3c64xx: add device tree support) requires
the DMACH_DT_PROP element in the dma_ch enum. It's not used on non-DT
platforms but has to be present nevertheless.

So mimic the dummy-add of DMACH_DT_PROP on s3c64xx for s3c24xx
machines, to correct the build breakage for the s3c24xx variants
using the s3c64xx-spi-driver.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-s3c24xx/include/mach/dma.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-s3c24xx/include/mach/dma.h
+++ b/arch/arm/mach-s3c24xx/include/mach/dma.h
@@ -24,7 +24,8 @@
 */
 
 enum dma_ch {
-	DMACH_XD0,
+	DMACH_DT_PROP = -1,	/* not yet supported, do not use */
+	DMACH_XD0 = 0,
 	DMACH_XD1,
 	DMACH_SDI,
 	DMACH_SPI0,


