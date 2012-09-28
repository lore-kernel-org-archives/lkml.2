Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032854Ab2I1UbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:31:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36926 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032845Ab2I1Ua6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= 
	<jprvita@openbossa.org>,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: =?UTF-8?q?=5B=20176/218=5D=20Bluetooth=3A=20Fix=20sending=20a=20HCI=20Authorization=20Request=20over=20LE=20links?=
Date: Fri, 28 Sep 2012 13:16:33 -0700
Message-Id: <20120928201521.716036943@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>

commit d8343f125710fb596f7a88cd756679f14f4e77b9 upstream.

In the case that the link is already in the connected state and a
Pairing request arrives from the mgmt interface, hci_conn_security()
would be called but it was not considering LE links.

Reported-by: João Paulo Rechi Vita <jprvita@openbossa.org>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_conn.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -42,6 +42,7 @@
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/smp.h>
 
 static void hci_le_connect(struct hci_conn *conn)
 {
@@ -661,6 +662,9 @@ int hci_conn_security(struct hci_conn *c
 {
 	BT_DBG("conn %p", conn);
 
+	if (conn->type == LE_LINK)
+		return smp_conn_security(conn, sec_level);
+
 	/* For sdp we don't need the link key. */
 	if (sec_level == BT_SECURITY_SDP)
 		return 1;


