Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0IVLUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:20:10 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:28279 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754037Ab0IVLUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:20:06 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: gyENorgVM1nA8faJuyVgchNjP6n9M7RKYk2M7AtP6UPYfsf
 4ihK.rZrR4RwoELhKjrBDmIQmDqZZw30OR5xDLk5hebSJ9tEku8QmMYnj24z
 _GWMBxuZCLka.Rd1Yh0TUF_P04kgBEKiKNSZRs5A8JxrykvAydxwzF0Bks7H
 CaBeUyKZpIlOhhuVyj.JY5Y_oZnfxKXkYOpAPHicn8fSGEpHy1BWJgmUT2RH
 66DBYPNoauXR5qwZt5pptWhux71hILDJc6SObVTLZxVJ_5HUHxI3euyk_ZLM
 OE_8Vt5Sfm5lCbiEBoAVkUqwrfI8nsbDP9d1LJFfrCMpF8ltUv2BoToSU_ln
 OsrNC9r7pfNaAdh7Yhg--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joel Becker <Joel.Becker@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 2/2] tcm: Remove struct list_head lookup from core_dev_[add,del]_initiator_node_lun_acl()
Date: Wed, 22 Sep 2010 04:20:03 -0700
Message-Id: <1285154403-6405-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the usage of core_tpg_get_initiator_node_acl() that contains an
unnecessary lookup of struct se_node_acl from struct se_portal_group->acl_node_list
which can be located directly via struct se_lun_acl->se_lun_nacl.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 6fe4408..1e8be47 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1524,7 +1524,7 @@ int core_dev_add_initiator_node_lun_acl(
 		return -EINVAL;
 	}
 
-	nacl = core_tpg_get_initiator_node_acl(tpg, lacl->initiatorname);
+	nacl = lacl->se_lun_nacl;
 	if (!(nacl))
 		return -EINVAL;
 
@@ -1569,7 +1569,7 @@ int core_dev_del_initiator_node_lun_acl(
 {
 	struct se_node_acl *nacl;
 
-	nacl = core_tpg_get_initiator_node_acl(tpg, lacl->initiatorname);
+	nacl = lacl->se_lun_nacl;
 	if (!(nacl))
 		return -EINVAL;
 
-- 
1.5.6.5

