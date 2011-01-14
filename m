Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab1ANJww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:52:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65351 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab1ANJwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:52:45 -0500
Message-ID: <4D3018FF.1010105@cn.fujitsu.com>
Date: Fri, 14 Jan 2011 17:35:59 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13pre) Gecko/20101113 Shredder/3.1.7pre
MIME-Version: 1.0
To: bfields@fieldses.org, neilb@suse.de, linux-nfs@vger.kernel.org,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] nfsd: kill unused macro definition
References: <4D300BA8.80000@cn.fujitsu.com>
In-Reply-To: <4D300BA8.80000@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 17:38:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-14 17:51:52,
	Serialize complete at 2011-01-14 17:51:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros had never been used for several years.
So, remove them.

Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
V2: add two other unused macros, EXPORT_HASHMASK and FILE_HASH_MASK.
 
---
 fs/nfsd/export.c    |    1 -
 fs/nfsd/nfs4idmap.c |    1 -
 fs/nfsd/nfs4state.c |    2 +-
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index c0fcb7a..98a964a 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -300,7 +300,6 @@ svc_expkey_update(struct svc_expkey *new, struct svc_expkey *old)
 
 #define	EXPORT_HASHBITS		8
 #define	EXPORT_HASHMAX		(1<< EXPORT_HASHBITS)
-#define	EXPORT_HASHMASK		(EXPORT_HASHMAX -1)
 
 static struct cache_head *export_table[EXPORT_HASHMAX];
 
diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index f0695e8..ce0f6b9 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -62,7 +62,6 @@ struct ent {
 
 #define ENT_HASHBITS          8
 #define ENT_HASHMAX           (1 << ENT_HASHBITS)
-#define ENT_HASHMASK          (ENT_HASHMAX - 1)
 
 static void
 ent_init(struct cache_head *cnew, struct cache_head *citm)
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fbd18c3..547fbc6 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -148,7 +148,7 @@ static struct list_head	ownerstr_hashtbl[OWNER_HASH_SIZE];
 /* hash table for nfs4_file */
 #define FILE_HASH_BITS                   8
 #define FILE_HASH_SIZE                  (1 << FILE_HASH_BITS)
-#define FILE_HASH_MASK                  (FILE_HASH_SIZE - 1)
+
 /* hash table for (open)nfs4_stateid */
 #define STATEID_HASH_BITS              10
 #define STATEID_HASH_SIZE              (1 << STATEID_HASH_BITS)
-- 
1.6.3.3
