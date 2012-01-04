Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2ADPD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:03:56 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:35903 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab2ADPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:03:48 -0500
From: Daniel Wagner <wagi@monom.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 2/3] Bluetooth: Use hci_conn_auth() instead of open coded version
Date: Wed,  4 Jan 2012 15:54:10 +0100
Message-Id: <1325688851-14920-3-git-send-email-wagi@monom.org>
X-Mailer: git-send-email 1.7.8.2.302.g17b4
In-Reply-To: <1325688851-14920-1-git-send-email-wagi@monom.org>
References: <1325688851-14920-1-git-send-email-wagi@monom.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Note this will also enable the encryption which will
not happen in the open coded version.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 net/bluetooth/hci_event.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index d37f5b2..453e483 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1296,11 +1296,7 @@ static void hci_cs_remote_name_req(struct hci_dev *hdev, __u8 status)
 	if (!hci_outgoing_auth_needed(hdev, conn))
 		goto unlock;
 
-	if (!test_and_set_bit(HCI_CONN_AUTH_PEND, &conn->pend)) {
-		struct hci_cp_auth_requested cp;
-		cp.handle = __cpu_to_le16(conn->handle);
-		hci_send_cmd(hdev, HCI_OP_AUTH_REQUESTED, sizeof(cp), &cp);
-	}
+	hci_conn_auth(conn, BT_SECURITY_HIGH, conn->auth_type);
 
 unlock:
 	hci_dev_unlock(hdev);
@@ -1814,11 +1810,7 @@ static inline void hci_remote_name_evt(struct hci_dev *hdev, struct sk_buff *skb
 	if (!hci_outgoing_auth_needed(hdev, conn))
 		goto unlock;
 
-	if (!test_and_set_bit(HCI_CONN_AUTH_PEND, &conn->pend)) {
-		struct hci_cp_auth_requested cp;
-		cp.handle = __cpu_to_le16(conn->handle);
-		hci_send_cmd(hdev, HCI_OP_AUTH_REQUESTED, sizeof(cp), &cp);
-	}
+	hci_conn_auth(conn, BT_SECURITY_HIGH, conn->auth_type);
 
 unlock:
 	hci_dev_unlock(hdev);
-- 
1.7.8.2.302.g17b4

