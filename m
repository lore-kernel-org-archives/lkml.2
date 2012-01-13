Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab2AMFlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 00:41:22 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:34123 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2AMFlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 00:41:20 -0500
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] blockdev: convert some macros to static inlines
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120112144215.595112f06f35d0072d5a334e@canb.auug.org.au>
	<yq1y5tdh8bu.fsf@sermon.lab.mkp.net> <4F0E96C6.9060404@kernel.dk>
Date: Fri, 13 Jan 2012 00:41:07 -0500
In-Reply-To: <4F0E96C6.9060404@kernel.dk> (Jens Axboe's message of "Thu, 12
	Jan 2012 09:16:06 +0100")
Message-ID: <yq1y5tcf9cc.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020204.4F0FC3F8.0006,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:
\
Jens> I'll take Stephens if you don't mind, I prefer the simplicity of
Jens> just typing out the functions.

Stephen's patch only converted half the stubs. Here's the rest...


block: Stop using macro stubs for the bio data integrity calls

Replace preprocessor macro stubs with real function declarations to
prevent warnings when CONFIG_BLK_DEV_INTEGRITY is disabled.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 847994a..129a9c0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -515,24 +515,64 @@ extern void bio_integrity_init(void);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
-#define bio_integrity(a)		(0)
-#define bioset_integrity_create(a, b)	(0)
-#define bio_integrity_prep(a)		(0)
-#define bio_integrity_enabled(a)	(0)
+static inline int bio_integrity(struct bio *bio)
+{
+	return 0;
+}
+
+static inline int bio_integrity_enabled(struct bio *bio)
+{
+	return 0;
+}
+
+static inline int bioset_integrity_create(struct bio_set *bs, int pool_size)
+{
+	return 0;
+}
+
+static inline void bioset_integrity_free (struct bio_set *bs)
+{
+	return;
+}
+
+static inline int bio_integrity_prep(struct bio *bio)
+{
+	return 0;
+}
+
+static inline void bio_integrity_free(struct bio *bio, struct bio_set *bs)
+{
+	return;
+}
+
 static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 				      gfp_t gfp_mask, struct bio_set *bs)
 {
 	return 0;
 }
-#define bioset_integrity_free(a)	do { } while (0)
-#define bio_integrity_free(a, b)	do { } while (0)
-#define bio_integrity_endio(a, b)	do { } while (0)
-#define bio_integrity_advance(a, b)	do { } while (0)
-#define bio_integrity_trim(a, b, c)	do { } while (0)
-#define bio_integrity_split(a, b, c)	do { } while (0)
-#define bio_integrity_set_tag(a, b, c)	do { } while (0)
-#define bio_integrity_get_tag(a, b, c)	do { } while (0)
-#define bio_integrity_init(a)		do { } while (0)
+
+static inline void bio_integrity_split(struct bio *bio, struct bio_pair *bp,
+				       int sectors)
+{
+	return;
+}
+
+static inline void bio_integrity_advance(struct bio *bio,
+					 unsigned int bytes_done)
+{
+	return;
+}
+
+static inline void bio_integrity_trim(struct bio *bio, unsigned int offset,
+				      unsigned int sectors)
+{
+	return;
+}
+
+static inline void bio_integrity_init(void)
+{
+	return;
+}
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
