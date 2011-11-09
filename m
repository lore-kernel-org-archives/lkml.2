Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936247Ab1KJECm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:02:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965771Ab1KJDqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:46:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:03 2011
Message-Id: <20111109213203.674639039@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [211/264] iscsi-target: Add missing CMDSN_LOWER_THAN_EXP check in iscsit_handle_scsi_cmd
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 7e32da55e26b80d57961681e53aa67938268db3f upstream.

This patch adds a missing CMDSN_LOWER_THAN_EXP return check for
iscsit_sequence_cmd() in iscsit_handle_scsi_cmd() that was incorrectly
dropped during the v3.1-rc cleanups to use iscsit_sequence_cmd().

Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/iscsi/iscsi_target.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1079,7 +1079,9 @@ attach_cmd:
 	 */
 	if (!cmd->immediate_data) {
 		cmdsn_ret = iscsit_sequence_cmd(conn, cmd, hdr->cmdsn);
-		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
+		if (cmdsn_ret == CMDSN_LOWER_THAN_EXP)
+			return 0;
+		else if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
 			return iscsit_add_reject_from_cmd(
 				ISCSI_REASON_PROTOCOL_ERROR,
 				1, 0, buf, cmd);


