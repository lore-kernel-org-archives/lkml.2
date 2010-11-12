Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab0KLDAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:00:06 -0500
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:10064 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754061Ab0KLDAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:00:05 -0500
Subject: [PATCH v7 0/3] Generic exponentially weighted moving average (EWMA)
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, br1@thinktube.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
Date: Fri, 12 Nov 2010 12:00:19 +0900
Message-ID: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a generic exponentially weighted moving average (EWMA) library
function and uses it from ath5k and mac80211. There are more places within
mac80211 and other wireless drivers which could benefit from this function,
which I'm going to update later and I hope this function can be useful in many
places all over the kernel. 

As it has been discussed on LKML, the preferred way of merging this is thru
wireless-testing, since this is where the first callers will be
(http://marc.info/?l=linux-kernel&m=128949956117559&w=2).

Thanks,
Bruno

---

Bruno Randolf (3):
      Add generic exponentially weighted moving average (EWMA) function
      ath5k: Use generic EWMA library
      nl80211/mac80211: Report signal average


 drivers/net/wireless/ath/ath5k/Kconfig |    1 +
 drivers/net/wireless/ath/ath5k/ani.c   |    4 +-
 drivers/net/wireless/ath/ath5k/ath5k.h |   26 +--------------
 drivers/net/wireless/ath/ath5k/base.c  |    4 +-
 drivers/net/wireless/ath/ath5k/debug.c |    2 +
 include/linux/average.h                |   32 ++++++++++++++++++
 include/linux/nl80211.h                |    2 +
 include/net/cfg80211.h                 |    4 ++
 lib/Kconfig                            |    3 ++
 lib/Makefile                           |    2 +
 lib/average.c                          |   57 ++++++++++++++++++++++++++++++++
 net/mac80211/Kconfig                   |    1 +
 net/mac80211/cfg.c                     |    3 +-
 net/mac80211/rx.c                      |    1 +
 net/mac80211/sta_info.c                |    2 +
 net/mac80211/sta_info.h                |    3 ++
 net/wireless/nl80211.c                 |    3 ++
 17 files changed, 120 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/average.h
 create mode 100644 lib/average.c

-- 
Signature
