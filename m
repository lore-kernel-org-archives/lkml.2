Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab1LPTtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:49:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760669Ab1LPTtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:58 2011
Message-Id: <20111216194558.091555085@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [25/53] iscsi-target: Add missing F_BIT for iscsi_tm_rsp
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 7ae0b1038f9f7d4c91e9afd4dbbc98210bf1a241 upstream.

This patch sets the missing ISCSI_FLAG_CMD_FINAL bit in
iscsit_send_task_mgt_rsp() for a struct iscsi_tm_rsp PDU.

This usage is hardcoded for all TM response PDUs in RFC-3720
section 10.6.

Reported-by: whucecil <whucecil1999@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/iscsi/iscsi_target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3134,6 +3134,7 @@ static int iscsit_send_task_mgt_rsp(
 	hdr			= (struct iscsi_tm_rsp *) cmd->pdu;
 	memset(hdr, 0, ISCSI_HDR_LEN);
 	hdr->opcode		= ISCSI_OP_SCSI_TMFUNC_RSP;
+	hdr->flags		= ISCSI_FLAG_CMD_FINAL;
 	hdr->response		= iscsit_convert_tcm_tmr_rsp(se_tmr);
 	hdr->itt		= cpu_to_be32(cmd->init_task_tag);
 	cmd->stat_sn		= conn->stat_sn++;


