Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab1GVESv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 00:18:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54841 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1GVESu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 00:18:50 -0400
Date: Fri, 22 Jul 2011 14:18:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the trivial tree with the net tree
Message-Id: <20110722141842.963b38d45ebf8cb5d0a25fcf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/net/r8169.c between commit b6ffd97f5bcf ("r8169: move the
firmware down into the device private data") (and others) from the net
tree and commit 497888cf69bf ("treewide: fix potentially dangerous
trailing ';' in
#defined values/expressions") from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/r8169.c
index 40bcb82,6f36306..0000000
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@@ -682,19 -666,8 +682,19 @@@ struct rtl8169_private 
  	struct rtl8169_counters counters;
  	u32 saved_wolopts;
  
 -	const struct firmware *fw;
 +	struct rtl_fw {
 +		const struct firmware *fw;
 +
 +#define RTL_VER_SIZE		32
 +
 +		char version[RTL_VER_SIZE];
 +
 +		struct rtl_fw_phy_action {
 +			__le32 *code;
 +			size_t size;
 +		} phy_action;
 +	} *rtl_fw;
- #define RTL_FIRMWARE_UNKNOWN	ERR_PTR(-EAGAIN);
+ #define RTL_FIRMWARE_UNKNOWN	ERR_PTR(-EAGAIN)
  };
  
  MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
