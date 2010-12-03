Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab0LCMQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:16:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:43983 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab0LCMQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:16:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,292,1288594800"; 
   d="scan'208";a="683567851"
Date: Fri, 3 Dec 2010 20:13:15 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, akpm@linux-foundation.org,
        arjan@linux.intel.com, alan@linux.intel.com, kmpark@infradead.org
Subject: [PATCH v2 0/4]enable Background operations and HPI feature for
	eMMC4.41 card
Message-ID: <20101203121315.GA18655@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
	This is the version 2 patch to enable background operations and HPI
	feature for eMMC4.41 card. Both of these two features are optional.

	Background operations can be started when user request queue is idle. So
	each time user start to handle a new request, driver should check
	whether the card is doing BKOPS. If so, should wait until BKOPS is done
	or use a HPI command to interrupt it if eMMC card support HPI. The
	serial patches were designed as this work flow.

	This version patch only use HPI to interrupt background operation,
	didnot implement to interrupt foreground operations.

	patch1: enable background operations feature for supported eMMC card.
	patch2: start to do background operations when user request queue is
	idle. Check whether card is doing BKOPS when start a new user request.
	patch3: enable HPI for supported eMMC card.
	patch4: use HPI command to interrupt BKOPS.

	change-log:

	patch2: remove the added workqueue in the version 1 patch. This
	workqueue is used to put card in runtime suspend state. Since current
	MMC driver has not a runtime power management in card block layer, just
	remove this workqueue. Define erro response to be macro R1_ERROR_RESPONSE

	patch3: fixed community comment. Thanks for Kyungmin Park.

Thanks
Chuanxiao
