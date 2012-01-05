Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2AEN0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:26:24 -0500
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:49805 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab2AEN0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:26:23 -0500
Subject: [PATCH v2 0/6] ath6kl: create ath6kl_core.ko
To: linville@tuxdriver.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, ath6kl-devel@qualcomm.com,
        davem@davemloft.net
Date: Thu, 05 Jan 2012 15:25:56 +0200
Message-ID: <20120105132523.22281.95999.stgit@x201>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the patchset to fix the allyesconfig build breakage. The fix is to
create a separate module ath6kl_core.ko which both ath6kl_sdio.ko and
ath6kl_usb.ko use.

v2:

o fix ath6kl_dbg() to use va_format correctly (thanks to joe)
o improved commit log in patch 4

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
 drivers/net/wireless/ath/ath6kl/debug.c    |   68 +++++-
 drivers/net/wireless/ath/ath6kl/debug.h    |   27 ---
 drivers/net/wireless/ath/ath6kl/hif.c      |   10 +
 drivers/net/wireless/ath/ath6kl/init.c     |  211 +-------------------
 drivers/net/wireless/ath/ath6kl/sdio.c     |    4 
 drivers/net/wireless/ath/ath6kl/usb.c      |    8 -
 drivers/net/wireless/ath/ath6kl/wmi.c      |    3 
 13 files changed, 484 insertions(+), 411 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/core.c

