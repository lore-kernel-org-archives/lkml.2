Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2BFHcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 02:32:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:54923 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2BFHcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 02:32:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121267483"
From: Huang Ying <ying.huang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>,
        Huang Ying <ying.huang@intel.com>
Subject: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
Date: Mon,  6 Feb 2012 15:32:23 +0800
Message-Id: <1328513548-19786-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSD becomes more and more popular, this makes it possible to put disk into
low power state more often.  And request based runtime PM for scsi disk is
more useful than open/close based one because disk is normally mounted at
most time.

One known issue, because SCSI TEST_UNIT_READY will be put into request
queue every 2 seconds by default, this makes it hard for disk to sleep.
Maybe we can implement check_events callback in some other way?

[RFC 1/5] pm, runtime, Add resume notifier
[RFC 2/5] scsi, pm, rename scsi_autopm_get/put_xxx to
[RFC 3/5] scsi, pm, add pm_runtime_get/put in scsi request
[RFC 4/5] scsi, pm, use autosuspend for scsi runtime PM
[RFC 5/5] scsi, sd, pm, request based runtime PM support

Best Regards,
Huang Ying
