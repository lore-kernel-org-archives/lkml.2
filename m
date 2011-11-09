Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965963Ab1KJDrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:47:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936072Ab1KJDrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:06 2011
Message-Id: <20111109213206.238605090@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [236/264] powerpc/pseries: Avoid spurious error during hotplug CPU add
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 9c740025c51a26ab00192cfc464064d4ccbfe3fc upstream.

During hotplug CPU add we get the following error:

Unexpected Error (0) returned from configure-connector

ibm,configure-connector returns 0 for configuration complete, so
catch this and avoid the error.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/dlpar.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -112,6 +112,7 @@ void dlpar_free_cc_nodes(struct device_n
 	dlpar_free_one_cc_node(dn);
 }
 
+#define COMPLETE	0
 #define NEXT_SIBLING    1
 #define NEXT_CHILD      2
 #define NEXT_PROPERTY   3
@@ -158,6 +159,9 @@ struct device_node *dlpar_configure_conn
 		spin_unlock(&rtas_data_buf_lock);
 
 		switch (rc) {
+		case COMPLETE:
+			break;
+
 		case NEXT_SIBLING:
 			dn = dlpar_parse_cc_node(ccwa);
 			if (!dn)


