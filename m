Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2ADXPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:15:53 -0500
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:48428 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab2ADXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:15:50 -0500
Subject: [PATCH 0/6] ath6kl: create ath6kl_core.ko
To: linville@tuxdriver.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, ath6kl-devel@qualcomm.com,
        davem@davemloft.net
Date: Thu, 05 Jan 2012 01:07:20 +0200
Message-ID: <20120104230429.32306.75965.stgit@x201>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the patchset to fix the allyesconfig build breakage. My fix is to
create a separate module ath6kl_core.ko which both ath6kl_sdio.ko and
ath6kl_usb.ko use. I have tested various combinations to make sure that
there are no compile errors anymore. Also allyesconfig build is running
right now.

Dave, please take a look and let me know if you prefer to fix this somehow
differently.

John, these patches are based your wireless-next tree, they do not even
apply to ath6kl.git. If the patches are ok, please take them directly to
get them faster to Dave.

Sorry again for this mess and taking so long to fix it.

---

Kalle Valo (6):
      ath6kl: rename vif init and cleanup functions
      ath6kl: unify cfg80211 init/cleanup functions
      ath6kl: create core.c
      ath6kl: get rid of AR_DBG_LVL_CHECK()
      ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump() into functions
      ath6kl: create ath6kl_core.ko


 drivers/net/wireless/ath/ath6kl/Makefile   |   35 +--
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  207 ++++++++------------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |   12 +
 drivers/net/wireless/ath/ath6kl/common.h   |    3 
 drivers/net/wireless/ath/ath6kl/core.c     |  297 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |   10 +
 drivers/net/wireless/ath/ath6kl/debug.c    |   62 ++++--
 drivers/net/wireless/ath/ath6kl/debug.h    |   27 ---
 drivers/net/wireless/ath/ath6kl/hif.c      |   10 +
 drivers/net/wireless/ath/ath6kl/init.c     |  211 +-------------------
 drivers/net/wireless/ath/ath6kl/sdio.c     |    4 
 drivers/net/wireless/ath/ath6kl/usb.c      |    8 -
 drivers/net/wireless/ath/ath6kl/wmi.c      |    3 
 13 files changed, 478 insertions(+), 411 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/core.c

