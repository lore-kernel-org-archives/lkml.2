Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2ADHSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 02:18:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17950 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2ADHSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 02:18:51 -0500
Date: Wed, 4 Jan 2012 10:18:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] dlm: le32 vs le16
Message-ID: <20120104071842.GB30978@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F03FD5A.0019,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->rf_our_slot and ->rf_num_slots are le16 so we should use cpu_to_le16()
here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 8f5a1b2..ac5c616 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -89,8 +89,8 @@ static void set_rcom_config(struct dlm_ls *ls, struct rcom_config *rf,
 	rf->rf_lvblen = cpu_to_le32(ls->ls_lvblen);
 	rf->rf_lsflags = cpu_to_le32(ls->ls_exflags);
 
-	rf->rf_our_slot = cpu_to_le32(ls->ls_slot);
-	rf->rf_num_slots = cpu_to_le32(num_slots);
+	rf->rf_our_slot = cpu_to_le16(ls->ls_slot);
+	rf->rf_num_slots = cpu_to_le16(num_slots);
 	rf->rf_generation =  cpu_to_le32(ls->ls_generation);
 }
 
