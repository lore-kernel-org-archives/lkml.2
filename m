Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2IMAfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:35:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab2ILXcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:32:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Ram Malovany <ramm@ti.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 040/108] Bluetooth: Set name_state to unknown when entry name is empty
Date: Wed, 12 Sep 2012 16:28:38 -0700
Message-Id: <20120912232454.727762687@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ram Malovany <ramm@ti.com>

commit c3e7c0d90b14a3e7ac091d24cef09efb516d587b upstream.

When the name of the given entry is empty , the state needs to be
updated accordingly.

Signed-off-by: Ram Malovany <ramm@ti.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1418,6 +1418,8 @@ static void hci_check_pending_name(struc
 		e->name_state = NAME_KNOWN;
 		mgmt_remote_name(hdev, bdaddr, ACL_LINK, 0x00,
 				 e->data.rssi, name, name_len);
+	} else {
+		e->name_state = NAME_NOT_KNOWN;
 	}
 
 	if (hci_resolve_next_name(hdev))


