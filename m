Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab0DMTWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:22:44 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55768 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857Ab0DMTWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:22:40 -0400
From: Jing Huang <huangj@Brocade.com>
To: <sfr@canb.auug.org.au>, <James.Bottomley@suse.de>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, <kgudipat@Brocade.com>,
       <rvadivel@Brocade.com>, <vravindr@Brocade.com>,
       Jing Huang <huangj@Brocade.com>
Subject: [PATCH] bfa: fix compilation warning in powerpc (resend)
Date: Tue, 13 Apr 2010 12:22:29 -0700
Message-ID: <1271186549-642-1-git-send-email-huangj@brocade.com>
X-Mailer: git-send-email 1.6.5.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166
 definitions=2010-04-13_07:2010-02-06,2010-04-13,2010-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=6.0.2-0911030000 definitions=main-1004130212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the compilation warning in powerpc. The same change also fixes endian
issue we found in powerpc test. This patch has been tested in x86 and
powerpc platform. it is created using scsi-misc-2.6.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_os_inc.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_os_inc.h b/drivers/scsi/bfa/bfa_os_inc.h
index 4eb1330..bd1cd3e 100644
--- a/drivers/scsi/bfa/bfa_os_inc.h
+++ b/drivers/scsi/bfa/bfa_os_inc.h
@@ -176,12 +176,12 @@ int bfa_os_MWB(void *);
 #define bfa_os_addr_t char __iomem *
 #define bfa_os_panic()
 
-#define bfa_os_reg_read(_raddr) bfa_os_wtole(readl(_raddr))
-#define bfa_os_reg_write(_raddr, _val) writel(bfa_os_wtole((_val)), (_raddr))
+#define bfa_os_reg_read(_raddr) readl(_raddr)
+#define bfa_os_reg_write(_raddr, _val) writel((_val), (_raddr))
 #define bfa_os_mem_read(_raddr, _off)                                   \
-	bfa_os_ntohl(readl(((_raddr) + (_off))))
+	bfa_os_swap32(readl(((_raddr) + (_off))))
 #define bfa_os_mem_write(_raddr, _off, _val)                            \
-	writel(bfa_os_htonl((_val)), ((_raddr) + (_off)))
+	writel(bfa_os_swap32((_val)), ((_raddr) + (_off)))
 
 #define BFA_TRC_TS(_trcm)						\
 			({						\
-- 
1.6.5.2

