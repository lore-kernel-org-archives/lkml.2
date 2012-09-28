Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031014Ab2I1TRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:17:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759081Ab2I1TFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:05:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= 
	<jprvita@openbossa.org>,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: =?UTF-8?q?=5B=20224/262=5D=20Bluetooth=3A=20Fix=20sending=20a=20HCI=20Authorization=20Request=20over=20LE=20links?=
Date: Fri, 28 Sep 2012 11:52:33 -0700
Message-Id: <20120928183024.669697579@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -627,6 +628,9 @@ int hci_conn_security(struct hci_conn *c
 {
 	BT_DBG("conn %p", conn);
 
+	if (conn->type == LE_LINK)
+		return smp_conn_security(conn, sec_level);
+
 	/* For sdp we don't need the link key. */
 	if (sec_level == BT_SECURITY_SDP)
 		return 1;


