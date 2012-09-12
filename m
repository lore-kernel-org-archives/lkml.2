Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab2IMANw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:13:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab2ILXie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:38:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Ram Malovany <ramm@ti.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 31/85] Bluetooth: Fix using NULL inquiry entry
Date: Wed, 12 Sep 2012 16:36:14 -0700
Message-Id: <20120912233545.002443697@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ram Malovany <ramm@ti.com>

commit c810089c27e48b816181b454fcc493d19fdbc2ba upstream.

If entry wasn't found in the hci_inquiry_cache_lookup_resolve do not
resolve the name.This will fix a kernel crash when trying to use NULL
pointer.

Signed-off-by: Ram Malovany <ramm@ti.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1357,6 +1357,9 @@ static bool hci_resolve_next_name(struct
 		return false;
 
 	e = hci_inquiry_cache_lookup_resolve(hdev, BDADDR_ANY, NAME_NEEDED);
+	if (!e)
+		return false;
+
 	if (hci_resolve_name(hdev, e) == 0) {
 		e->name_state = NAME_PENDING;
 		return true;


