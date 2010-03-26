Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0CZGNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:13:08 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:37162 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab0CZGNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=O2h10tw9BevvXHsVhd6rSxDLD/S9X/WFGPQi6CaGQXZQANHu2PPM24eQ+bvEm1KpKO
         FYki0/ILKNr8txVgk68PFY3qPZfwgrAxM0dn3W46ymO/BthrIpbztDuhQDLOD8G65UVe
         dlFYnHK1OVDTLtcVs554jIOGYuJedgoUWWfwc=
Date: Fri, 26 Mar 2010 14:12:59 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-drivers@serverengines.com,
       sathyap@serverengines.com
Subject: [PATCH] benet: Fix compile warnnings in drivers/net/benet/be_ethtool.c
Message-ID: <20100326061259.GB30341@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings:

be_ethtool.c:493: warning: integer constant is too large for 'long' type
be_ethtool.c:493: warning: integer constant is too large for 'long' type

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 drivers/net/benet/be_ethtool.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/benet/be_ethtool.c b/drivers/net/benet/be_ethtool.c
index 9560d48..51e1065 100644
--- a/drivers/net/benet/be_ethtool.c
+++ b/drivers/net/benet/be_ethtool.c
@@ -490,7 +490,7 @@ be_test_ddr_dma(struct be_adapter *adapter)
 {
 	int ret, i;
 	struct be_dma_mem ddrdma_cmd;
-	u64 pattern[2] = {0x5a5a5a5a5a5a5a5a, 0xa5a5a5a5a5a5a5a5};
+	u64 pattern[2] = {0x5a5a5a5a5a5a5a5aULL, 0xa5a5a5a5a5a5a5a5ULL};
 
 	ddrdma_cmd.size = sizeof(struct be_cmd_req_ddrdma_test);
 	ddrdma_cmd.va = pci_alloc_consistent(adapter->pdev, ddrdma_cmd.size,
-- 
1.6.5.3

