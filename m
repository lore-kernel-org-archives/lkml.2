Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab2ADPDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:03:52 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:35898 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2ADPDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:03:47 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jan 2012 10:03:47 EST
From: Daniel Wagner <wagi@monom.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 3/3] Bluetooth: Use hci_conn_encrypt() instead of open coded version
Date: Wed,  4 Jan 2012 15:54:11 +0100
Message-Id: <1325688851-14920-4-git-send-email-wagi@monom.org>
X-Mailer: git-send-email 1.7.8.2.302.g17b4
In-Reply-To: <1325688851-14920-1-git-send-email-wagi@monom.org>
References: <1325688851-14920-1-git-send-email-wagi@monom.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 net/bluetooth/hci_event.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 453e483..7a4262d 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1754,11 +1754,7 @@ static inline void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *s
 
 	if (conn->state == BT_CONFIG) {
 		if (!ev->status && hdev->ssp_mode > 0 && conn->ssp_mode > 0) {
-			struct hci_cp_set_conn_encrypt cp;
-			cp.handle  = ev->handle;
-			cp.encrypt = 0x01;
-			hci_send_cmd(hdev, HCI_OP_SET_CONN_ENCRYPT, sizeof(cp),
-									&cp);
+			hci_conn_encrypt(conn);
 		} else {
 			conn->state = BT_CONNECTED;
 			hci_proto_connect_cfm(conn, ev->status);
@@ -1774,11 +1770,7 @@ static inline void hci_auth_complete_evt(struct hci_dev *hdev, struct sk_buff *s
 
 	if (test_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend)) {
 		if (!ev->status) {
-			struct hci_cp_set_conn_encrypt cp;
-			cp.handle  = ev->handle;
-			cp.encrypt = 0x01;
-			hci_send_cmd(hdev, HCI_OP_SET_CONN_ENCRYPT, sizeof(cp),
-									&cp);
+			hci_conn_encrypt(conn);
 		} else {
 			clear_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend);
 			hci_encrypt_cfm(conn, ev->status, 0x00);
-- 
1.7.8.2.302.g17b4

