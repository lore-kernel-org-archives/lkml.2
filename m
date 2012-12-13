Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475Ab2LMOOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:14:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45117 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434Ab2LMOOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thierry Escande <thierry.escande@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 225/241] NFC: Fix nfc_llcp_local chained list insertion
Date: Thu, 13 Dec 2012 11:59:50 -0200
Message-Id: <1355407206-17100-226-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Escande <thierry.escande@linux.intel.com>

commit 16a78e9fed5e8baa8480ae3413f4328c4537c599 upstream.

list_add was called with swapped parameters

Signed-off-by: Thierry Escande <thierry.escande@linux.intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/nfc/llcp/llcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 42994fa..96781f5 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -990,7 +990,7 @@ int nfc_llcp_register_device(struct nfc_dev *ndev)
 	local->remote_lto = LLCP_DEFAULT_LTO;
 	local->remote_rw = LLCP_DEFAULT_RW;
 
-	list_add(&llcp_devices, &local->list);
+	list_add(&local->list, &llcp_devices);
 
 	return 0;
 
-- 
1.7.9.5

