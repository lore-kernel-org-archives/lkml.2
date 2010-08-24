Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308Ab0HXXgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:36:52 -0400
Received: from kroah.org ([198.145.64.141]:40364 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab0HXW6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:37 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:14 2010
Message-Id: <20100824224214.547850117@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:41:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Vasut <marek.vasut@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [29/91] ARM: Fix gen_nand probe structures contents
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Vasut <marek.vasut@gmail.com>

commit ef077179a2909d3d0d3accf29ad1ea9ebb19019b upstream.

These three platforms didn't properly fill nr_chips in gen_nand
registration and therefore depended on gen_nand bug fixed by commit
81cbb0b17796d81cbd92defe113cf2a7c7a21fbb ("mtd: gen_nand: fix support for
multiple chips")

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-ixp4xx/ixdp425-setup.c |    1 +
 arch/arm/mach-mx3/mach-qong.c        |    1 +
 arch/arm/mach-orion5x/ts78xx-setup.c |    1 +
 3 files changed, 3 insertions(+)

--- a/arch/arm/mach-ixp4xx/ixdp425-setup.c
+++ b/arch/arm/mach-ixp4xx/ixdp425-setup.c
@@ -100,6 +100,7 @@ ixdp425_flash_nand_cmd_ctrl(struct mtd_i
 
 static struct platform_nand_data ixdp425_flash_nand_data = {
 	.chip = {
+		.nr_chips		= 1,
 		.chip_delay		= 30,
 		.options		= NAND_NO_AUTOINCR,
 #ifdef CONFIG_MTD_PARTITIONS
--- a/arch/arm/mach-mx3/mach-qong.c
+++ b/arch/arm/mach-mx3/mach-qong.c
@@ -169,6 +169,7 @@ static void qong_nand_select_chip(struct
 
 static struct platform_nand_data qong_nand_data = {
 	.chip = {
+		.nr_chips		= 1,
 		.chip_delay		= 20,
 		.options		= 0,
 	},
--- a/arch/arm/mach-orion5x/ts78xx-setup.c
+++ b/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -216,6 +216,7 @@ static struct mtd_partition ts78xx_ts_na
 
 static struct platform_nand_data ts78xx_ts_nand_data = {
 	.chip	= {
+		.nr_chips		= 1,
 		.part_probe_types	= ts_nand_part_probes,
 		.partitions		= ts78xx_ts_nand_parts,
 		.nr_partitions		= ARRAY_SIZE(ts78xx_ts_nand_parts),


