Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2E2KGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:06:50 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47229 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501Ab2E2KGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:06:49 -0400
Date: Tue, 29 May 2012 12:06:46 +0200
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.cs.fau.de
Subject: [PATCH] mtd: dc21285.c: remove double check of CONFIG_ARCH_NETWINDER
Message-ID: <20120529100646.GA23383@faui49q.informatik.uni-erlangen.de>
References: <1338040464.2525.38.camel@koala>
 <20120525082812.GA12238@faui49q.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338040464.2525.38.camel@koala>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_ARCH_NETWINDER is unset nw_en_write is a NOP. But
machine_is_netwinder() also checks for
CONFIG_ARCH_NETWINDER. Therefore in the !netwinder case the
preprocessed code is:

if (0)
   do {} while(0);

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/mtd/maps/dc21285.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/maps/dc21285.c b/drivers/mtd/maps/dc21285.c
index 86598a1..38fbf23 100644
--- a/drivers/mtd/maps/dc21285.c
+++ b/drivers/mtd/maps/dc21285.c
@@ -79,8 +79,7 @@ static void dc21285_copy_from(struct map_info *map, void *to, unsigned long from
 
 static void dc21285_write8(struct map_info *map, const map_word d, unsigned long adr)
 {
-	if (machine_is_netwinder())
-		nw_en_write();
+	nw_en_write();
 	*CSR_ROMWRITEREG = adr & 3;
 	adr &= ~3;
 	*(uint8_t*)(map->virt + adr) = d.x[0];
@@ -88,8 +87,7 @@ static void dc21285_write8(struct map_info *map, const map_word d, unsigned long
 
 static void dc21285_write16(struct map_info *map, const map_word d, unsigned long adr)
 {
-	if (machine_is_netwinder())
-		nw_en_write();
+	nw_en_write();
 	*CSR_ROMWRITEREG = adr & 3;
 	adr &= ~3;
 	*(uint16_t*)(map->virt + adr) = d.x[0];
@@ -97,8 +95,7 @@ static void dc21285_write16(struct map_info *map, const map_word d, unsigned lon
 
 static void dc21285_write32(struct map_info *map, const map_word d, unsigned long adr)
 {
-	if (machine_is_netwinder())
-		nw_en_write();
+	nw_en_write();
 	*(uint32_t*)(map->virt + adr) = d.x[0];
 }
 
-- 
1.7.5.4

