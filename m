Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2ADHTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:19:43 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18202 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2ADHTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:19:39 -0500
Date: Wed, 4 Jan 2012 10:19:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Whitehouse <swhiteho@redhat.com>,
        David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] gfs2: make some sizes unsigned in set_recover_size()
Message-ID: <20120104071931.GC30978@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F03FD89.00A6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ls->ls_recover_size is uint32_t so old_size and new_size should be
unsigned as well.  Otherwise a large value could count as a negative
and we could get past the "if (old_size >= max_jid + 1)" check by
mistake.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 82c82d0..400d041 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -886,7 +886,8 @@ static int set_recover_size(struct gfs2_sbd *sdp, struct dlm_slot *slots,
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
 	uint32_t *submit = NULL;
 	uint32_t *result = NULL;
-	int i, max_jid, old_size, new_size;
+	uint32_t old_size, new_size;
+	int i, max_jid;
 
 	max_jid = 0;
 	for (i = 0; i < num_slots; i++) {
