Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab2HaUBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:01:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53118 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab2HaUBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:01:02 -0400
From: dongsu.park@profitbricks.com
To: bvanassche@acm.org
Cc: dillowda@ornl.gov, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, JBottomley@parallels.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH 0/5] Fix bugs in ib_srp patches for H.A. purposes
Date: Fri, 31 Aug 2012 22:00:36 +0200
Message-Id: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsu Park <dongsu.park@profitbricks.com>

Hi Bart,

This patchset aims at fixing bugs that have been discovered in our own
SRP test environment so far. These patches are based on your patchset v4,
"Make ib_srp better suited for H.A. purposes",(09 Aug 2012).

The 5th patch, "fix an error accessing invalid memory in
rport_dev_loss_timedout" is including your suggestion (30 Aug 2012).

You can also pull the following git repo to get the patches.

  git://github.com/advance38/linux.git srp-ha

Our test setup consists of two systems.
Kernel 3.2.15 with SCST v4193 on the target,
and Kernel 3.2.8 with ib_srp-ha on the initiator.
Although I rebased the patches again onto 3.6-rc3,
I suppose there will be no significant differences.

All of the known critical issues seem to have been resolved
according to our internal tests in the last weeks.

Thanks,

Dongsu Park (3):
  ib_srp: free memory correctly in srp_free_iu()
  ib_srp: hold a mutex when adding a new target port
  ib_srp: check if rport->lld_data is NULL before removing rport

Sebastian Riemer (1):
  ib_srp: removed superfluous warning in send timeout case

Bart Van Assche (1):
  ib_srp: fix an error accessing invalid memory in
    rport_dev_loss_timedout

 drivers/infiniband/ulp/srp/ib_srp.c | 23 +++++++++++++++++++----
 drivers/scsi/scsi_transport_srp.c   | 11 ++++++++++-
 2 files changed, 29 insertions(+), 5 deletions(-)

-- 
1.7.11.1

