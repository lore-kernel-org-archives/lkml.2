Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2ADOea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 09:34:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51046 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2ADOeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:34:25 -0500
Date: Wed, 4 Jan 2012 15:34:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH 2/2] ARM: mach-shmobile: specify CHCLR registers on SH7372
In-Reply-To: <Pine.LNX.4.64.1201041528570.30506@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201041533370.30506@axis700.grange>
References: <Pine.LNX.4.64.1201041528570.30506@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:nZUCqaLlM5Q1rPfyD5AaRx/YrkmjSoIX1dVLNyE31AN
 2v5kDeQQJlsUoIFzGI00BqD/AcJPI4R5dTUBAnjJLd2Lo/iYKv
 1q3dpUwfApdkx6x9JSFHswWiuJehIrF6hV+pZSXkLJkGkyHFQz
 ZVk9WWblQQElfY5rdf3fNbMWypG5QnZ0/nZAOkI+xrYI7xn2+T
 SGRBTHX/O3w51DQYwRwP3kVDmik7XhyYTQeTivjrfIeoJ7qLYr
 0FjyzQkRpD9WPDoiRbymzRBEqy7xdQFWqDCuuDNuwy3v6tkrAl
 PJvfLq/UCiNCN2uLKIe2cx8JR93bv02RMXuutx4Etj/rTj625j
 735bnl/H/sJBix4RH6LnIKASg6gm1i8DJ4UHWcc0L14h2BClgz
 ajlcBlQGAK5Sw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-shmobile/setup-sh7372.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index 2380389..83dc940 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -445,31 +445,39 @@ static const struct sh_dmae_slave_config sh7372_dmae_slaves[] = {
 	},
 };
 
+#define SH7372_CHCLR 0x220
+
 static const struct sh_dmae_channel sh7372_dmae_channels[] = {
 	{
 		.offset = 0,
 		.dmars = 0,
 		.dmars_bit = 0,
+		.chclr_offset = SH7372_CHCLR + 0,
 	}, {
 		.offset = 0x10,
 		.dmars = 0,
 		.dmars_bit = 8,
+		.chclr_offset = SH7372_CHCLR + 0x10,
 	}, {
 		.offset = 0x20,
 		.dmars = 4,
 		.dmars_bit = 0,
+		.chclr_offset = SH7372_CHCLR + 0x20,
 	}, {
 		.offset = 0x30,
 		.dmars = 4,
 		.dmars_bit = 8,
+		.chclr_offset = SH7372_CHCLR + 0x30,
 	}, {
 		.offset = 0x50,
 		.dmars = 8,
 		.dmars_bit = 0,
+		.chclr_offset = SH7372_CHCLR + 0x50,
 	}, {
 		.offset = 0x60,
 		.dmars = 8,
 		.dmars_bit = 8,
+		.chclr_offset = SH7372_CHCLR + 0x60,
 	}
 };
 
@@ -487,6 +495,7 @@ static struct sh_dmae_pdata dma_platform_data = {
 	.ts_shift	= ts_shift,
 	.ts_shift_num	= ARRAY_SIZE(ts_shift),
 	.dmaor_init	= DMAOR_DME,
+	.chclr_present	= 1,
 };
 
 /* Resource order important! */
@@ -494,7 +503,7 @@ static struct resource sh7372_dmae0_resources[] = {
 	{
 		/* Channel registers and DMAOR */
 		.start	= 0xfe008020,
-		.end	= 0xfe00808f,
+		.end	= 0xfe00828f,
 		.flags	= IORESOURCE_MEM,
 	},
 	{
@@ -522,7 +531,7 @@ static struct resource sh7372_dmae1_resources[] = {
 	{
 		/* Channel registers and DMAOR */
 		.start	= 0xfe018020,
-		.end	= 0xfe01808f,
+		.end	= 0xfe01828f,
 		.flags	= IORESOURCE_MEM,
 	},
 	{
@@ -550,7 +559,7 @@ static struct resource sh7372_dmae2_resources[] = {
 	{
 		/* Channel registers and DMAOR */
 		.start	= 0xfe028020,
-		.end	= 0xfe02808f,
+		.end	= 0xfe02828f,
 		.flags	= IORESOURCE_MEM,
 	},
 	{
-- 
1.7.2.5

