Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1HWDCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 23:02:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40898 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab1HWDCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 23:02:19 -0400
Date: Tue, 23 Aug 2011 13:02:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Zhang Shu <davidshuzhang@gmail.com>,
        Chu Xiaowei <chuxiaowei@mprc.pku.edu.cn>,
        Su Yonggang <tonyhook.su@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: manual merge of the net tree with the unicore32 tree
Message-Id: <20110823130210.766d466d689d60536f59340a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got conflicts in
drivers/net/Kconfig and drivers/net/Makefile between commit e8787de6fa83
("unicore32: add pkunity-v3 mac/net driver (umal)") from the unicore32
tree and the network driver rearrangement from the net tree.

I just added the new driver from the unicore32 tree commit into each file
(see below).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index ef6b6be..df5e990 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -215,6 +215,12 @@ source "drivers/s390/net/Kconfig"
 
 source "drivers/net/caif/Kconfig"
 
+config MAC_PUV3
+	tristate "PKUnity v3 UMAL Gigabit Network Adapter support"
+	depends on UNICORE32 && ARCH_PUV3
+	select MII
+	select PHYLIB
+
 config XEN_NETDEV_FRONTEND
 	tristate "Xen network device frontend driver"
 	depends on XEN
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index c33009b..9896ad1 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_RIONET) += rionet.o
 
 obj-$(CONFIG_NET) += Space.o loopback.o
 obj-$(CONFIG_NET_SB1000) += sb1000.o
+obj-$(CONFIG_MAC_PUV3) += mac-puv3.o
 obj-$(CONFIG_PPP) += ppp_generic.o
 obj-$(CONFIG_PPP_ASYNC) += ppp_async.o
 obj-$(CONFIG_PPP_SYNC_TTY) += ppp_synctty.o
