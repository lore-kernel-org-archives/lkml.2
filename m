Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab2BJXNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:13:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab2BJWm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:28 -0500
MIME-Version: 1.0
Message-Id: <20120210222949.837569902@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [patch 54/86] iscsi-target: Fix double list_add with iscsit_alloc_buffs reject
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit cd931ee62fd0258fc85c76a7c5499fe85e0f3436 upstream.

This patch fixes a bug where the iscsit_add_reject_from_cmd() call
from a failure to iscsit_alloc_buffs() was incorrectly passing
add_to_conn=1 and causing a double list_add after iscsi_cmd->i_list
had already been added in iscsit_handle_scsi_cmd().

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1062,7 +1062,7 @@ attach_cmd:
 	if (ret < 0)
 		return iscsit_add_reject_from_cmd(
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
-				1, 1, buf, cmd);
+				1, 0, buf, cmd);
 	/*
 	 * Check the CmdSN against ExpCmdSN/MaxCmdSN here if
 	 * the Immediate Bit is not set, and no Immediate


