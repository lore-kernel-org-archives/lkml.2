Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab1I1Gg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:36:59 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54465 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1I1Gg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:36:58 -0400
Date: Wed, 28 Sep 2011 16:36:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the moduleh tree with the net tree
Message-Id: <20110928163656.4d0ec3d9d40471f4e051605f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/net/wireless/p54/txrx.c between commit 1cda0fd60963 ("p54: Use
do_div for 64-bit division to fix 32-bit kernels") from the  tree and
commit 9ec3f961e31a ("drivers/net: Add export.h to files using
EXPORT_SYMBOL/THIS_MODULE") from the moduleh tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/p54/txrx.c
index 2b97a89,d5c12bc..0000000
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@@ -19,7 -19,7 +19,8 @@@
  #include <linux/init.h>
  #include <linux/firmware.h>
  #include <linux/etherdevice.h>
+ #include <linux/export.h>
 +#include <asm/div64.h>
  
  #include <net/mac80211.h>
  
