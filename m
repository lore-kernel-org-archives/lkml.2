Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab0LAMvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:51:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:54579 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0LAMvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:51:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,283,1288594800"; 
   d="scan'208";a="355488537"
Date: Wed, 1 Dec 2010 20:48:42 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, arjan@linux.intel.com,
        alan@linux.intel.com, akpm@linux-foundation.org
Subject: [PATCH v4 0/4]implement eMMC4.4 standard HW reset feature
Message-ID: <20101201124842.GA5421@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	These are the version 4 patches to implement eMMC4.4 HW reset
	feature. Host controller can use this feature by trigger RST_n signal.
	To enable this, byte 162 of EXT_CSD register should be set.
	HW reset is implemented in mmc core layer and sdhci host layer, and it
	will be used after each reading/writing/erasing timeout error occures.

	change-log:
	This version change the way to detect timeout error conditions. Added a
	new routine mmc_handle_timeout_error to do this instead to do this in
	mmc_wait_for_req. Each timeout read/write/erase command can use this
	routine to do HW reset.

	patch1: enable HW reset capability if card support.

	patch2: add two new callback to implement HW reset in mmc core layer. In
	this patch, routine mmc_handle_timeout_error was added.

	patch3: implement hardware_reset callback for sdhci host. A new callback
	reset_emmc was defined which will be each sdhci host controller to
	implement separately.

	patch4: did a HW reset after each read/write/erase command.

Thanks
Chuanxiao
