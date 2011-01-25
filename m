Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1AYEtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 23:49:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab1AYEtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 23:49:22 -0500
Date: Tue, 25 Jan 2011 12:49:10 +0800
From: Eugene Teo <eugeneteo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Kees Cook <kees.cook@canonical.com>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: net: clear heap allocation for ethtool_get_regs()
Message-ID: <20110125044910.GB8117@infradead.org>
Reply-To: Eugene Teo <eugeneteo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a conflict between commit b00916b1 and a77f5db3. This patch resolves
the conflict by clearing the heap allocation in ethtool_get_regs().

Cc: stable@kernel.org
Signed-off-by: Eugene Teo <eugeneteo@kernel.org>

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 1774178..ff23029 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -817,7 +817,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = vmalloc(reglen);
+	regbuf = vzalloc(reglen);
 	if (!regbuf)
 		return -ENOMEM;
 
