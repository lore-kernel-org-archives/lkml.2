Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2JGXeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:34:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38522 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab2JGXWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:54 -0400
Message-Id: <20121007225843.000001548@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        =?ISO-8859-15?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= 
	<jprvita@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 060/108] Bluetooth: Fix sending a HCI Authorization Request over LE links
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>

commit d8343f125710fb596f7a88cd756679f14f4e77b9 upstream.

In the case that the link is already in the connected state and a
Pairing request arrives from the mgmt interface, hci_conn_security()
would be called but it was not considering LE links.

Reported-by: João Paulo Rechi Vita <jprvita@openbossa.org>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/hci_conn.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -44,6 +44,7 @@
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/smp.h>
 
 static void hci_le_connect(struct hci_conn *conn)
 {
@@ -641,6 +642,9 @@ int hci_conn_security(struct hci_conn *c
 {
 	BT_DBG("conn %p", conn);
 
+	if (conn->type == LE_LINK)
+		return smp_conn_security(conn, sec_level);
+
 	/* For sdp we don't need the link key. */
 	if (sec_level == BT_SECURITY_SDP)
 		return 1;


