Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab0HXXCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:02:14 -0400
Received: from kroah.org ([198.145.64.141]:40993 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397Ab0HXXCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:02 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:04 2010
Message-Id: <20100824224504.400213091@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Vasut <marek.vasut@gmail.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [036/114] BFIN: Fix gen_nand probe structures contents
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Vasut <marek.vasut@gmail.com>

commit ef56609f9c7fdf5baa9d9f86f84a7bd8a717cd25 upstream.

These two platforms didn't properly fill nr_chips in gen_nand
registration and therefore depended on gen_nand bug fixed by by commit
81cbb0b17796d81cbd92defe113cf2a7c7a21fbb ("mtd: gen_nand: fix support for
multiple chips")

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/blackfin/mach-bf537/boards/stamp.c   |    1 +
 arch/blackfin/mach-bf561/boards/acvilon.c |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -400,6 +400,7 @@ static int bfin_plat_nand_dev_ready(stru
 
 static struct platform_nand_data bfin_plat_nand_data = {
 	.chip = {
+		.nr_chips = 1,
 		.chip_delay = 30,
 #ifdef CONFIG_MTD_PARTITIONS
 		.part_probe_types = part_probes,
--- a/arch/blackfin/mach-bf561/boards/acvilon.c
+++ b/arch/blackfin/mach-bf561/boards/acvilon.c
@@ -284,6 +284,7 @@ static int bfin_plat_nand_dev_ready(stru
 
 static struct platform_nand_data bfin_plat_nand_data = {
 	.chip = {
+		 .nr_chips = 1,
 		 .chip_delay = 30,
 #ifdef CONFIG_MTD_PARTITIONS
 		 .part_probe_types = part_probes,


