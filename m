Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0I2FyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:54:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab0I2FyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:54:05 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, edgar.iglesias@gmail.com, duyl@xilinx.com,
        linnj@xilinx.com, grant.likely@secretlab.ca,
        microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 6/7] microblaze: KGDB little endian support
Date: Wed, 29 Sep 2010 15:52:17 +1000
Message-Id: <1285739538-29058-7-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1285739538-29058-6-git-send-email-monstr@monstr.eu>
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
 <1285739538-29058-2-git-send-email-monstr@monstr.eu>
 <1285739538-29058-3-git-send-email-monstr@monstr.eu>
 <1285739538-29058-4-git-send-email-monstr@monstr.eu>
 <1285739538-29058-5-git-send-email-monstr@monstr.eu>
 <1285739538-29058-6-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just need to use little-endian opcode for brki r16, 0x18

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Jason Wessel <jason.wessel@windriver.com>
---
 arch/microblaze/kernel/kgdb.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/kernel/kgdb.c b/arch/microblaze/kernel/kgdb.c
index 9b5a817..09a5e82 100644
--- a/arch/microblaze/kernel/kgdb.c
+++ b/arch/microblaze/kernel/kgdb.c
@@ -142,5 +142,9 @@ void kgdb_arch_exit(void)
  * Global data
  */
 struct kgdb_arch arch_kgdb_ops = {
+#ifdef __MICROBLAZEEL__
+	.gdb_bpt_instr = {0x18, 0x00, 0x0c, 0xba}, /* brki r16, 0x18 */
+#else
 	.gdb_bpt_instr = {0xba, 0x0c, 0x00, 0x18}, /* brki r16, 0x18 */
+#endif
 };
-- 
1.5.5.1

