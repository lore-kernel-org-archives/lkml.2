Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab2K3TIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:08:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:59792 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993082Ab2K3TCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thierry Escande <thierry.escande@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>
Subject: [ 47/54] NFC: Fix nfc_llcp_local chained list insertion
Date: Fri, 30 Nov 2012 10:56:18 -0800
Message-Id: <20121130185212.649078272@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Escande <thierry.escande@linux.intel.com>

commit 16a78e9fed5e8baa8480ae3413f4328c4537c599 upstream.

list_add was called with swapped parameters

Signed-off-by: Thierry Escande <thierry.escande@linux.intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/llcp/llcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -1190,7 +1190,7 @@ int nfc_llcp_register_device(struct nfc_
 	local->remote_miu = LLCP_DEFAULT_MIU;
 	local->remote_lto = LLCP_DEFAULT_LTO;
 
-	list_add(&llcp_devices, &local->list);
+	list_add(&local->list, &llcp_devices);
 
 	return 0;
 


