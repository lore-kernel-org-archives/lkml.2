Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab1JNOeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:34:19 -0400
Received: from lunge.queued.net ([173.255.254.236]:36764 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab1JNOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:34:18 -0400
Date: Fri, 14 Oct 2011 07:33:20 -0700
From: Andres Salomon <dilinger@queued.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] mtd: provide an alias for the redboot module name
Message-ID: <20111014073320.140fb4b2@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_mtd_partitions takes a list of partition types; if the driver
isn't loaded, it attempts to load it, and then it grabs the partition
parser.  For redboot, the module name is "redboot.ko", while the parser
name is "RedBoot".  Since modprobe is case-sensitive, attempting to
modprobe "RedBoot" will never work.  I suspect the embedded systems that
make use of redboot just always manually loaded redboot prior to loading
their specific nand chip drivers (or statically compiled it in).

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: stable@kernel.org
---
 drivers/mtd/redboot.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

v2: instead of renaming the module, use a module_alias.  Duh.  Thanks,
Artem Bityutskiy!

diff --git a/drivers/mtd/redboot.c b/drivers/mtd/redboot.c
index 7a87d07..4938bd0 100644
--- a/drivers/mtd/redboot.c
+++ b/drivers/mtd/redboot.c
@@ -297,6 +297,9 @@ static struct mtd_part_parser redboot_parser = {
 	.name = "RedBoot",
 };
 
+/* mtd parsers will request the module by parser name */
+MODULE_ALIAS("RedBoot");
+
 static int __init redboot_parser_init(void)
 {
 	return register_mtd_parser(&redboot_parser);
-- 
1.7.2.5

