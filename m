Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab2CUJsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:48:41 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:59469 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab2CUJsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:48:40 -0400
Subject: [PATCH] mtd: phram: fix section mismatch for phram_setup
From: Ryosuke Saito <raitosyo@gmail.com>
To: artem.bityutskiy@linux.intel.com
Cc: h-fache@ti.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Mar 2012 18:47:47 +0900
Message-ID: <1332323267.14283.13.camel@HDL00099>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

phram_setup() is only called from init_phram() which is in .init.text,
so it must be in the same section to avoid a section mismatch warning.

Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>
---
 drivers/mtd/devices/phram.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index 3d91ace..67823de 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -215,7 +215,7 @@ static inline void kill_final_newline(char *str)
  */
 static __initdata char phram_paramline[64+12+12];
 
-static int phram_setup(const char *val)
+static int __init phram_setup(const char *val)
 {
 	char buf[64+12+12], *str = buf;
 	char *token[3];
-- 
1.7.3.4

