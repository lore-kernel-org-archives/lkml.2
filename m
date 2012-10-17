Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2JQHjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:39:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2JQHjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:39:53 -0400
From: Hannes Reinecke <hare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH] ramoops: Fixup section annotations
Date: Wed, 17 Oct 2012 09:39:49 +0200
Message-Id: <1350459589-55210-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler complained about missing section annotations.
Fix it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>

---
 fs/pstore/ram.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1a4f6da..2b6ebbc 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -287,8 +287,9 @@ static void ramoops_free_przs(struct ramoops_context *cxt)
 	kfree(cxt->przs);
 }
 
-static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
-			      phys_addr_t *paddr, size_t dump_mem_sz)
+static int __devinit ramoops_init_przs(struct device *dev,
+				       struct ramoops_context *cxt,
+				       phys_addr_t *paddr, size_t dump_mem_sz)
 {
 	int err = -ENOMEM;
 	int i;
@@ -326,9 +327,10 @@ fail_prz:
 	return err;
 }
 
-static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
-			    struct persistent_ram_zone **prz,
-			    phys_addr_t *paddr, size_t sz, u32 sig)
+static int __devinit ramoops_init_prz(struct device *dev,
+				      struct ramoops_context *cxt,
+				      struct persistent_ram_zone **prz,
+				      phys_addr_t *paddr, size_t sz, u32 sig)
 {
 	if (!sz)
 		return 0;
-- 
1.7.4.2

