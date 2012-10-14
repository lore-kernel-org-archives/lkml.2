Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2JNOoN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:44:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46731 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932301Ab2JNOoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:07 -0400
Message-Id: <20121014143539.679155579@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
Subject: [ 043/147] iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT
 PDU
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9cfdeed..30842e1 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3427,6 +3427,7 @@ static int iscsit_send_reject(
 	hdr->opcode		= ISCSI_OP_REJECT;
 	hdr->flags		|= ISCSI_FLAG_CMD_FINAL;
 	hton24(hdr->dlength, ISCSI_HDR_LEN);
+	hdr->ffffffff		= 0xffffffff;
 	cmd->stat_sn		= conn->stat_sn++;
 	hdr->statsn		= cpu_to_be32(cmd->stat_sn);
 	hdr->exp_cmdsn	= cpu_to_be32(conn->sess->exp_cmd_sn);


