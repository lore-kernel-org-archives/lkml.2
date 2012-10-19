Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965054Ab2JSDd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:33:26 -0400
Received: from mail.kernel.org ([198.145.19.201]:51089 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab2JSCrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 12/62] iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT PDU
Date: Thu, 18 Oct 2012 19:44:40 -0700
Message-Id: <20121019024257.917393710@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit f25590f39d543272f7ae7b00d533359c8d7ff331 upstream.

This patch adds a missing iscsi_reject->ffffffff assignment within
iscsit_send_reject() code to properly follow RFC-3720 Section 10.17
Bytes 16 -> 19 for the PDU format definition of ISCSI_OP_REJECT.

We've not seen any initiators care about this bytes in practice, but
as Ronnie reported this was causing trouble with wireshark packet
decoding lets go ahead and fix this up now.

Reported-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3349,6 +3349,7 @@ static int iscsit_send_reject(
 	hdr->opcode		= ISCSI_OP_REJECT;
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
 	hton24(hdr->dlength, ISCSI_HDR_LEN);
+	hdr->ffffffff		= 0xffffffff;
 	cmd->stat_sn		= conn->stat_sn++;
 	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
 	hdr->exp_cmdsn	= cpu_to_be32(conn->sess->exp_cmd_sn);


