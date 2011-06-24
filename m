Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1FXNJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:09:06 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2150 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1FXNJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:09:04 -0400
X-Greylist: delayed 952 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jun 2011 09:09:03 EDT
Message-ID: <4E0488A9.6050109@imgtec.com>
Date: Fri, 24 Jun 2011 13:52:57 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Matt Fleming <matt@console-pimps.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: james@albanarts.com
Subject: [PATCH 0/6] mmc: dw_mmc: misc fixes and improvements
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2011 12:52:58.0460 (UTC) FILETIME=[A4CCA1C0:01CC326D]
X-SEF-Processed: 7_3_0_01158__2011_06_24_13_53_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Misc improvements and fixes for the Synopsys DesignWare MMC driver:

[PATCH 1/6] mmc: dw_mmc: clear TXDR/RXDR ints before enabling
	fixes a failure to probe the next card after an unplug
[PATCH 2/6] mmc: dw_mmc: fix race with request and removal
	improves spinlock protection
[PATCH 3/6] mmc: dw_mmc: convert card tasklet to workqueue
	to allow platform callbacks to sleep
[PATCH 4/6] mmc: dw_mmc: brackets in register access macros
	just a small tidyup patch
[PATCH 5/6] mmc: dw_mmc: don't hard code fifo depth, fix usage
	improve detection of fifo depth
[PATCH 6/6] mmc: dw_mmc: handle unaligned buffers and sizes
	fix some mmc_test failures wrt unaligned buffer/sizes
 
 drivers/mmc/host/dw_mmc.c  |  398 ++++++++++++++++++++++++++++++++++----------
 drivers/mmc/host/dw_mmc.h  |   17 +-
 include/linux/mmc/dw_mmc.h |   20 ++-
 3 files changed, 340 insertions(+), 95 deletions(-)

