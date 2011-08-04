Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1HDHFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:05:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48128 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1HDHFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:05:46 -0400
Subject: [PATCH] drivers/of: Fix sparc build failure caused by of_alias_scan
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, Shawn Guo <shawn.guo@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 04 Aug 2011 08:05:42 +0100
Message-ID: <20110804070033.20042.28741.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 750f463a, "dt: add of_alias_scan and of_alias_get_id" breaks
platforms that don't use CONFIG_OF_FLATTREE, like SPARC and OLPC.  Fix
it by only building it on platforms using the flat tree.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi Linus,

Hand me the paper bag, I completely screwed up that last commit.  The
previous commit fixes imx, but breaks SPARC.  I apologize, and rightly
accept any due punishment.

This patch fixes it, and it is also pushed out to devicetree/next:

The following changes since commit
a9e4e6e14c322e08d1c615afc8f504fb415f9613:

Merge branch 'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending
(2011-08-03 15:12:09 -1000)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/next

Grant Likely (1):
      drivers/of: Fix sparc build failure caused by of_alias_scan

 drivers/of/base.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index fb28b5a..c81a0fe 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1013,6 +1013,7 @@ out_unlock:
 }
 #endif /* defined(CONFIG_OF_DYNAMIC) */
 
+#ifdef CONFIG_OF_FLATTREE
 static void of_alias_add(struct alias_prop *ap, struct device_node *np,
 			 int id, const char *stem, int stem_len)
 {
@@ -1118,3 +1119,4 @@ int of_alias_get_id(struct device_node *np, const char *stem)
 	return id;
 }
 EXPORT_SYMBOL_GPL(of_alias_get_id);
+#endif /* CONFIG_OF_FLATTREE */

