Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab2ADPDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:03:54 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:35899 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2ADPDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:03:47 -0500
From: Daniel Wagner <wagi@monom.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: [RFC v0 1/3] Bluetooth: Make hci_conn_auth/encrypt public functions
Date: Wed,  4 Jan 2012 15:54:09 +0100
Message-Id: <1325688851-14920-2-git-send-email-wagi@monom.org>
X-Mailer: git-send-email 1.7.8.2.302.g17b4
In-Reply-To: <1325688851-14920-1-git-send-email-wagi@monom.org>
References: <1325688851-14920-1-git-send-email-wagi@monom.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
---
 include/net/bluetooth/hci_core.h |    2 ++
 net/bluetooth/hci_conn.c         |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ea9231f..301b86b 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -527,6 +527,8 @@ void hci_chan_list_flush(struct hci_conn *conn);
 struct hci_conn *hci_connect(struct hci_dev *hdev, int type, bdaddr_t *dst,
 						__u8 sec_level, __u8 auth_type);
 int hci_conn_check_link_mode(struct hci_conn *conn);
+int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type);
+void hci_conn_encrypt(struct hci_conn *conn);
 int hci_conn_check_secure(struct hci_conn *conn, __u8 sec_level);
 int hci_conn_security(struct hci_conn *conn, __u8 sec_level, __u8 auth_type);
 int hci_conn_change_link_key(struct hci_conn *conn);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 07bc69e..da49b9c 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -616,7 +616,7 @@ int hci_conn_check_link_mode(struct hci_conn *conn)
 EXPORT_SYMBOL(hci_conn_check_link_mode);
 
 /* Authenticate remote device */
-static int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
+int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 {
 	BT_DBG("conn %p", conn);
 
@@ -650,7 +650,7 @@ static int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 }
 
 /* Encrypt the the link */
-static void hci_conn_encrypt(struct hci_conn *conn)
+void hci_conn_encrypt(struct hci_conn *conn)
 {
 	BT_DBG("conn %p", conn);
 
-- 
1.7.8.2.302.g17b4

