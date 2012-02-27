Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2B0VWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:22:44 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30129 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2B0VU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:28 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 17/22] bio: add bvec_length(), like iov_length()
Date: Mon, 27 Feb 2012 15:19:31 -0600
Message-Id: <1330377576-3659-18-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090201.4F4BF39C.004E,ss=1,re=0.000,fgs=0
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
1.7.9.2

