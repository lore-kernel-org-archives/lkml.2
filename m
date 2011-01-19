Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab1ASQUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:20:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52358 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab1ASQUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:20:31 -0500
Subject: [PATCH] powerpc/83xx: fix build failures on dt compatible list.
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        galak@kernel.crashing.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 19 Jan 2011 09:20:28 -0700
Message-ID: <20110119161908.25999.76832.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a4f740cf, "of/flattree: Add of_flat_dt_match() helper function"
introduced build failures in arch/powerpc/platform/83xx by mistyping
'static' as 'struct' in the compatible string list, and omitting a few
semicolons.  This patch fixes it.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Ben, I can put this one into my merge-devicetree branch and I'll ask Linus
to merge it in a few days.


 arch/powerpc/platforms/83xx/mpc830x_rdb.c |    4 ++--
 arch/powerpc/platforms/83xx/mpc831x_rdb.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/mpc830x_rdb.c b/arch/powerpc/platforms/83xx/mpc830x_rdb.c
index 661d354..d0c4e15 100644
--- a/arch/powerpc/platforms/83xx/mpc830x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc830x_rdb.c
@@ -57,12 +57,12 @@ static void __init mpc830x_rdb_init_IRQ(void)
 	ipic_set_default_priority();
 }
 
-struct const char *board[] __initdata = {
+static const char *board[] __initdata = {
 	"MPC8308RDB",
 	"fsl,mpc8308rdb",
 	"denx,mpc8308_p1m",
 	NULL
-}
+};
 
 /*
  * Called very early, MMU is off, device-tree isn't unflattened
diff --git a/arch/powerpc/platforms/83xx/mpc831x_rdb.c b/arch/powerpc/platforms/83xx/mpc831x_rdb.c
index b54cd73..f859ead 100644
--- a/arch/powerpc/platforms/83xx/mpc831x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc831x_rdb.c
@@ -60,11 +60,11 @@ static void __init mpc831x_rdb_init_IRQ(void)
 	ipic_set_default_priority();
 }
 
-struct const char *board[] __initdata = {
+static const char *board[] __initdata = {
 	"MPC8313ERDB",
 	"fsl,mpc8315erdb",
 	NULL
-}
+};
 
 /*
  * Called very early, MMU is off, device-tree isn't unflattened

