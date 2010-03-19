Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab0CSB3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 21:29:46 -0400
Received: from mail.perches.com ([173.55.12.10]:1846 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab0CSB3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 21:29:44 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Geoff Levand <geoffrey.levand@am.sony.com>, Zhu Yi <yi.zhu@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pavel Roskin <proski@gnu.org>,
       David Gibson <hermes@gibson.dropbear.id.au>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       orinoco-devel@lists.sourceforge.net
Subject: [PATCH v3 0/9] wireless: Use macros from wireless.h
Date: Thu, 18 Mar 2010 18:29:31 -0700
Message-Id: <cover.1268961559.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a IW_HANDLER macro for iw_handler array entries in wireless.h
Use the wireless.h macros in various wireless files
Use starting index define SIOCIWFIRST where appropriate 
Remove local #defines of IW_IOCTL
Remove STD_IW_HANDLER macro in orinoco, use IW_HANDLER instead

Joe Perches (9):
  include/linux/wireless.h: Add IW_HANDLER macro to initialize array entry
  wireless.h: Use SIOCIWFIRST not SIOCSIWCOMMIT for range check
  include/net/iw_handler.h: Use SIOCIWFIRST not SIOCSIWCOMMIT in comment
  net/wireless/wext_core.c: Use IW_IOCTL_IDX macro
  net/wireless/wext-core.c: Use IW_EVENT_IDX macro
  drivers/net/wireless: Use IW_HANDLER macro
  drivers/net: Remove local #define IW_IOCTL, use IW_HANDLER
  orinoco/wext.c: Remove local #define STD_IW_HANDLER
  drivers/net/wireless/ray_cs.c: Use iw_handler function prototypes

 drivers/net/ps3_gelic_wireless.c       |   35 +++---
 drivers/net/wireless/ipw2x00/ipw2200.c |   83 ++++++-------
 drivers/net/wireless/orinoco/wext.c    |   94 +++++++-------
 drivers/net/wireless/ray_cs.c          |  212 +++++++++++++++-----------------
 drivers/net/wireless/wl3501_cs.c       |   52 ++++----
 include/linux/wireless.h               |    4 +-
 include/net/iw_handler.h               |    2 +-
 net/wireless/wext-core.c               |  134 ++++++++++----------
 8 files changed, 298 insertions(+), 318 deletions(-)
