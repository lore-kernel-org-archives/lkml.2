Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1HaNn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:43:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:5192 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab1HaNn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:43:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,307,1312182000"; 
   d="scan'208";a="44294812"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 00/12] staging: mei: adding new watchdog core support
Date: Wed, 31 Aug 2011 16:42:36 +0300
Message-Id: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patches set we are adding the new watchdog core to the mei driver.
Until now the mei driver manage by itself the Intel(R) Active Management Technology 
(Intel(R) AMT) watchdog, the driver send the heartbeat by a 
internal timer and the internal was defined by module parameter.

for more information about the Intel(R) AMT watchdog read
drivers/staging/mei/mei.txt

Oren Weil (12):
  staging: mei: removing dependency between WD and AMTHI init function.
  staging: mei: fix register access function comments
  staging: mei: registering the MEI driver with the kernel watchdog
    core interface
  staging: mei: adding watchdog ops
  staging: mei: adding watchdog ping
  staging: mei: adding set_timeout watchdog function
  staging: mei: renaming delayed work field and function to a
    meaningful name.
  staging: mei: resuming timer regardless of the watchdog timeout
    value.
  stagign: mei: client init code cleanup
  staging: mei: removing wd module parameters
  staging: mei: adding mei_wd_stop function comment
  staging: mei: adding watchdog core dependency to kconfig

 drivers/staging/mei/Kconfig     |    2 +-
 drivers/staging/mei/init.c      |    9 ++-
 drivers/staging/mei/interface.h |    8 +-
 drivers/staging/mei/interrupt.c |   45 +++-----
 drivers/staging/mei/main.c      |   19 ++--
 drivers/staging/mei/mei_dev.h   |   22 +++-
 drivers/staging/mei/wd.c        |  241 ++++++++++++++++++++++++++++++++------
 7 files changed, 260 insertions(+), 86 deletions(-)

-- 
1.7.4.1

