Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0F0GsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 02:48:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64699 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0F0Gro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 02:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lpigvDXbVNOGCGLTmD2RDqu6fZU5cbOMm+1woLhnADvE9zLMBAbO24WooJ+PkQTs/X
         TA+Nekkd21U+d8poQ48eqgSHWtQqiLUg/TrMIY80QEd9RdXzAfxdFjMsXGbQnvUJth3R
         uaxh4wHtw3Zj9E+KaCSY4IRDofUO7QEDEPjVQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, sds@tycho.nsa.gov, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/5]security:ebitmap.c Fix warning: variable 'e_sft' set but not used
Date: Sat, 26 Jun 2010 23:47:23 -0700
Message-Id: <1277621246-10960-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc is giving me this during compiling:
  CC      security/selinux/ss/ebitmap.o
security/selinux/ss/ebitmap.c: In function 'ebitmap_netlbl_import':
security/selinux/ss/ebitmap.c:159:27: warning: variable 'e_sft' set but not used

The below fixes this warning for me.
(please check this whenever you have time).
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 security/selinux/ss/ebitmap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/security/selinux/ss/ebitmap.c b/security/selinux/ss/ebitmap.c
index 04b6145..b7980ee 100644
--- a/security/selinux/ss/ebitmap.c
+++ b/security/selinux/ss/ebitmap.c
@@ -156,7 +156,7 @@ int ebitmap_netlbl_import(struct ebitmap *ebmap,
 	struct ebitmap_node *e_iter = NULL;
 	struct ebitmap_node *emap_prev = NULL;
 	struct netlbl_lsm_secattr_catmap *c_iter = catmap;
-	u32 c_idx, c_pos, e_idx, e_sft;
+	u32 c_idx, c_pos, e_idx;
 
 	/* NetLabel's NETLBL_CATMAP_MAPTYPE is defined as an array of u64,
 	 * however, it is not always compatible with an array of unsigned long
@@ -190,7 +190,6 @@ int ebitmap_netlbl_import(struct ebitmap *ebmap,
 			}
 			delta = c_pos - e_iter->startbit;
 			e_idx = delta / EBITMAP_UNIT_SIZE;
-			e_sft = delta % EBITMAP_UNIT_SIZE;
 			while (map) {
 				e_iter->maps[e_idx++] |= map & (-1UL);
 				map = EBITMAP_SHIFT_UNIT_SIZE(map);
-- 
1.7.1.rc1.21.gf3bd6

