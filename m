Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1HNQLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:11:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab1HNQKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:59 2011
Message-Id: <20110812210559.515776903@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [84/90] e1000e: alternate MAC address does not work on device id 0x1060
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bruce Allan <bruce.w.allan@intel.com>

commit c407bee8a56d874b91f3e4ee790660959ff1a25e upstream.

This issue is present all the way back to 2.6.34 kernels.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Jeffrey Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -190,7 +190,8 @@ s32 e1000_check_alt_mac_addr_generic(str
 	/* Check for LOM (vs. NIC) or one of two valid mezzanine cards */
 	if (!((nvm_data & NVM_COMPAT_LOM) ||
 	      (hw->adapter->pdev->device == E1000_DEV_ID_82571EB_SERDES_DUAL) ||
-	      (hw->adapter->pdev->device == E1000_DEV_ID_82571EB_SERDES_QUAD)))
+	      (hw->adapter->pdev->device == E1000_DEV_ID_82571EB_SERDES_QUAD) ||
+	      (hw->adapter->pdev->device == E1000_DEV_ID_82571EB_SERDES)))
 		goto out;
 
 	ret_val = e1000_read_nvm(hw, NVM_ALT_MAC_ADDR_PTR, 1,


