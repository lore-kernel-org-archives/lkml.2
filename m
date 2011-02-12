Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab1BLG2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 01:28:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:43271 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1BLG2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 01:28:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,460,1291622400"; 
   d="scan'208";a="706948116"
Date: Sat, 12 Feb 2011 14:22:07 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        adrian.hunter@nokia.com
Subject: [PATCH v4 0/3]mmc: enable TRIM/ERASE caps for SDHCI host
Message-ID: <20110212062207.GA25519@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,
   These patches enable TRIM/ERASE capability for SDHCI host controller.

   patch001: mmc: set max_discard_sectors value for mmc queue
   Rightnow max_discard_sectors value for mmc queue is UINT_MAX which means
   block layer can accept unlimited sectors to erase at one time. But this may
   delay some other important I/O requests. So set a suitable value for
   max_discard_sectors value by using 'pref_erase'

   patch0002: mmc: enable TRIM/ERASE capability for SDHCI host.
   ERASE command needs R1B response, so before sending command, SDHCI host
   driver also need to set timeout control register for such command

   patch0003: mmc: fix division by zero when calculate erase timeout
   when enable clock gating feature, host clock may be zero when calculate erase
   timeout value and this will cause division by zero bug.

Thanks
Chuanxiao
