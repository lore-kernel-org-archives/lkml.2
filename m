Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0KJVTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:19:09 -0500
Received: from mail.perches.com ([173.55.12.10]:4935 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab0KJVTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:19:08 -0500
Subject: [PATCH] fs/gfs2/glock.h: Add __attribute__((format(printf,2,3)) to
 gfs2_print_dbg
From: Joe Perches <joe@perches.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <1289422527.2438.20.camel@dolmen>
References: <cover.1289348757.git.joe@perches.com>
	 <5918196ac71b4e3184a534643cdf499b54416541.1289348757.git.joe@perches.com>
	 <1289422527.2438.20.camel@dolmen>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 13:19:06 -0800
Message-ID: <1289423946.15905.103.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions that use printf formatting, especially
those that use %pV, should have their uses of
printf format and arguments checked by the compiler.

Signed-off-by: Joe Perches <joe@perches.com>
---
No current uses report any error in an allyesconfig build.
 
 fs/gfs2/glock.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index db1c26d..a12d117 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -212,6 +212,8 @@ int gfs2_glock_nq_num(struct gfs2_sbd *sdp,
 int gfs2_glock_nq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs);
+
+__attribute__ ((format(printf, 2, 3)))
 void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...);
 
 /**


