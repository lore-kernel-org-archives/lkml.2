Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab0LQMqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab0LQMqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:22 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/15] GFS2: Fix uninitialised error value in previous patch
Date: Fri, 17 Dec 2010 12:24:18 +0000
Message-Id: <1292588661-14350-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index ae7d205..3c4039d 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -763,7 +763,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	int metadata;
 	unsigned int revokes = 0;
 	int x;
-	int error;
+	int error = 0;
 
 	if (!*top)
 		sm->sm_first = 0;
-- 
1.7.3.3

