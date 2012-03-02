Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab2CBG5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:57:55 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17846 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2CBG5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:57:53 -0500
Date: Fri, 2 Mar 2012 09:57:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] megaraid: cleanup type issue in mega_build_cmd()
Message-ID: <20120302065741.GD24508@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F506F6D.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64 bit systems the current code sets 32 bits of "seg" and leaves the
other 32 uninitialized.  It doesn't matter since the variable is never
used.  But it's still messy and we should fix it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 4d39a9f..97825f1 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -524,7 +524,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 	mega_passthru	*pthru;
 	scb_t	*scb;
 	mbox_t	*mbox;
-	long	seg;
+	u32	seg;
 	char	islogical;
 	int	max_ldrv_num;
 	int	channel = 0;
@@ -858,7 +858,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 
 			/* Calculate Scatter-Gather info */
 			mbox->m_out.numsgelements = mega_build_sglist(adapter, scb,
-					(u32 *)&mbox->m_out.xferaddr, (u32 *)&seg);
+					(u32 *)&mbox->m_out.xferaddr, &seg);
 
 			return scb;
 
