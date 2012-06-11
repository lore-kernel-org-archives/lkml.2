Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2FKMxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:53:45 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:42754 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2FKMxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:53:42 -0400
Date: Mon, 11 Jun 2012 21:30:02 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: grundler@parisc-linux.org
Cc: bhutchings@solarflare.com, arnd@arndb.de, avi@redhat.com,
        mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [PATCH 2/4] drivers/net/ethernet/dec/tulip: Add tulip_ prefix to
 set_bit_le()
Message-Id: <20120611213002.caaf0e05.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120611212735.f92ea521.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120611212735.f92ea521.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

Needed to introduce generic set_bit_le().

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Grant Grundler <grundler@parisc-linux.org>
---
 drivers/net/ethernet/dec/tulip/de2104x.c    |    7 +++----
 drivers/net/ethernet/dec/tulip/tulip_core.c |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 61cc093..e635f1a 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -661,8 +661,7 @@ static netdev_tx_t de_start_xmit (struct sk_buff *skb,
    new frame, not around filling de->setup_frame.  This is non-deterministic
    when re-entered but still correct. */
 
-#undef set_bit_le
-#define set_bit_le(i,p) do { ((char *)(p))[(i)/8] |= (1<<((i)%8)); } while(0)
+#define tulip_set_bit_le(i,p) do { ((char *)(p))[(i)/8] |= (1<<((i)%8)); } while(0)
 
 static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 {
@@ -673,12 +672,12 @@ static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 	u16 *eaddrs;
 
 	memset(hash_table, 0, sizeof(hash_table));
-	set_bit_le(255, hash_table); 			/* Broadcast entry */
+	tulip_set_bit_le(255, hash_table);		/* Broadcast entry */
 	/* This should work on big-endian machines as well. */
 	netdev_for_each_mc_addr(ha, dev) {
 		int index = ether_crc_le(ETH_ALEN, ha->addr) & 0x1ff;
 
-		set_bit_le(index, hash_table);
+		tulip_set_bit_le(index, hash_table);
 	}
 
 	for (i = 0; i < 32; i++) {
diff --git a/drivers/net/ethernet/dec/tulip/tulip_core.c b/drivers/net/ethernet/dec/tulip/tulip_core.c
index c4f37ac..3a1ebd02 100644
--- a/drivers/net/ethernet/dec/tulip/tulip_core.c
+++ b/drivers/net/ethernet/dec/tulip/tulip_core.c
@@ -1010,8 +1010,7 @@ static int private_ioctl (struct net_device *dev, struct ifreq *rq, int cmd)
    new frame, not around filling tp->setup_frame.  This is non-deterministic
    when re-entered but still correct. */
 
-#undef set_bit_le
-#define set_bit_le(i,p) do { ((char *)(p))[(i)/8] |= (1<<((i)%8)); } while(0)
+#define tulip_set_bit_le(i,p) do { ((char *)(p))[(i)/8] |= (1<<((i)%8)); } while(0)
 
 static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 {
@@ -1022,12 +1021,12 @@ static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 	u16 *eaddrs;
 
 	memset(hash_table, 0, sizeof(hash_table));
-	set_bit_le(255, hash_table); 			/* Broadcast entry */
+	tulip_set_bit_le(255, hash_table);		/* Broadcast entry */
 	/* This should work on big-endian machines as well. */
 	netdev_for_each_mc_addr(ha, dev) {
 		int index = ether_crc_le(ETH_ALEN, ha->addr) & 0x1ff;
 
-		set_bit_le(index, hash_table);
+		tulip_set_bit_le(index, hash_table);
 	}
 	for (i = 0; i < 32; i++) {
 		*setup_frm++ = hash_table[i];
-- 
1.7.5.4

