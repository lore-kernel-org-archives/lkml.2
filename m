Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1JVEVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 00:21:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62235 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1JVEVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 00:21:52 -0400
From: Paul Schilling <paul.s.schilling@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Paul Schilling <Paul.S.Schilling@gmail.com>,
        Paul Schilling <paul.s.schilling@gmail.com>
Subject: [PATCH 06/14] ARM : SAMSUNG : S3C2416 Added io mapping for Static memory controller.
Date: Fri, 21 Oct 2011 23:21:41 -0500
Message-Id: <1319257301-5040-1-git-send-email-paul.s.schilling@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <static_memory>
References: <static_memory>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added MMU access to the Static Memory Controller.

Signed-off-by: Paul Schilling <paul.s.schilling@gmail.com>
---
 arch/arm/mach-s3c2416/s3c2416.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2416/s3c2416.c b/arch/arm/mach-s3c2416/s3c2416.c
index 494ce91..823a034 100644
--- a/arch/arm/mach-s3c2416/s3c2416.c
+++ b/arch/arm/mach-s3c2416/s3c2416.c
@@ -65,6 +65,18 @@ static struct map_desc s3c2416_iodesc[] __initdata = {
 	IODESC_ENT(WATCHDOG),
 	IODESC_ENT(CLKPWR),
 	IODESC_ENT(TIMER),
+	{
+		.virtual	= (u32)S3C2412_VA_SSMC,
+		.pfn		= __phys_to_pfn(S3C2412_PA_SSMC),
+		.length		= SZ_1M,
+		.type		= MT_DEVICE,
+	},
+	/*{
+		.virtual	= (u32)S3C2412_VA_EBI,
+		.pfn		= __phys_to_pfn(S3C2412_PA_EBI),
+		.length		= SZ_1M,
+		.type		= MT_DEVICE,
+	},*/
 };
 
 struct sysdev_class s3c2416_sysclass = {
-- 
1.7.6.4

