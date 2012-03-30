Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146Ab2C3Ps7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:48:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46948 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933839Ab2C3Poa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:44:30 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH v2 14/21] bio: add bvec_length(), like iov_length()
Date: Fri, 30 Mar 2012 10:43:41 -0500
Message-Id: <1333122228-13633-15-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F75D4DE.0005,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 include/linux/bio.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 129a9c0..913087d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -268,6 +268,14 @@ extern struct bio_vec *bvec_alloc_bs(gfp_t, int, unsigned long *, struct bio_set
 extern void bvec_free_bs(struct bio_set *, struct bio_vec *, unsigned int);
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
+static inline ssize_t bvec_length(const struct bio_vec *bvec, unsigned long nr)
+{
+	ssize_t bytes = 0;
+	while (nr--)
+		bytes += (bvec++)->bv_len;
+	return bytes;
+}
+
 /*
  * bio_set is used to allow other portions of the IO system to
  * allocate their own private memory pools for bio and iovec structures.
-- 
1.7.9.5

