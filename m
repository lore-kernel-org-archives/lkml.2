Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3ACMR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:17:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab3ACMQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:16:34 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Nathan Straz <nstraz@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: Initialize hex string to '0'
Date: Thu,  3 Jan 2013 11:50:07 +0000
Message-Id: <1357213810-3739-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1357213810-3739-1-git-send-email-swhiteho@redhat.com>
References: <1357213810-3739-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Straz <nstraz@redhat.com>

When generating the DLM lock name, a value of 0 would skip
the loop and leave the string unchanged.  This left locks with
a value of 0 unlabeled.  Initializing the string to '0' fixes this.

Signed-off-by: Nathan Straz <nstraz@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 8dad6b0..b906ed1 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -241,6 +241,7 @@ static u32 make_flags(struct gfs2_glock *gl, const unsigned int gfs_flags,
 
 static void gfs2_reverse_hex(char *c, u64 value)
 {
+	*c = '0';
 	while (value) {
 		*c-- = hex_asc[value & 0x0f];
 		value >>= 4;
-- 
1.7.4

