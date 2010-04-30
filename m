Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab0D3SPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:15:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58768 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127Ab0D3SPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:15:15 -0400
Date: Fri, 30 Apr 2010 14:08:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2010-04-30
Message-ID: <20100430180840.GD4120@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

One more for 2.6.34...it avoids some DMA mapping-related failures.

Please let me know if there are problems!

Thanks,

John

---

The following changes since commit 03f80cc3f24e1dcdbdba081ed5daf5575aac6180:
  Sebastian Siewior (1):
        net/sb1250: register mdio bus in probe

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Hans de Goede (1):
      p54pci: fix bugs in p54p_check_tx_ring

 drivers/net/wireless/p54/p54pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index ed4bdff..21f673d 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -245,7 +245,7 @@ static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
 	u32 idx, i;
 
 	i = (*index) % ring_limit;
-	(*index) = idx = le32_to_cpu(ring_control->device_idx[1]);
+	(*index) = idx = le32_to_cpu(ring_control->device_idx[ring_index]);
 	idx %= ring_limit;
 
 	while (i != idx) {
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
