Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab0LBL2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:28:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:39272 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab0LBL2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:28:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208";a="683149762"
Date: Thu, 2 Dec 2010 19:25:26 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, arjan@linux.intel.com,
        alan@linux.intel.com, akpm@linux-foundation.org,
        adrian.hunter@nokia.com
Subject: [PATVH v3 0/3]mmc: set a suitable max_discard_sectors value for HC
Message-ID: <20101202112526.GA10358@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	This is the version 3 patch which set a suitable max_discard_sectors
	value for SDHCI host controller. In this patch, a new quirk is added for
	such controller.

	max_discard_sectors is a parameter of MMC driver request queue. This
	value can limit how many sectors will be passed down to host for
	erasing. The original value for this parameter is UINT_MAX which means
	there is no limitation for the count of sectors to pass down for
	erasing.

	But some SDHCI host controller cannot erase too many sectors at one
	time. It may generate a timeout interrupt since the time erasing used is
	longer than the timeout time host can wait.

	So these patches add a new quirk for such SDHCI host controller and let
	it erase only signle eraseblock each time. This will be safe for such
	SDHCI host to use.

	patch1: add a new quirk for SDHCI host controller. Also add a new
	routine mmc_set_discard_limit which is used to set max_discard_sectors
	value for such SDHCI host controller.
	patch2: set timeout control register for such SDHCI host controller.
	patch3: add this quirk for MFLD SDHCI host controller.

	Change-log:
	patch1: let mmc_set_discard_limit can return value UINT_MAX.
	patch2: no change.
	patch3: no change.

Thanks
Chuanxiao
