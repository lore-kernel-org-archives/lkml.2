Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1EGCzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:55:11 -0400
Received: from nm19-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.25]:25246
	"HELO nm19-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754632Ab1EGCzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:55:09 -0400
X-Yahoo-Newman-Id: 801011.71063.bm@omp1019.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: nxEF9kwVM1lgCk8a0u_s9AW4gJPbvHwLjEZLnPrXZ_CKF7C
 ZE5xMPhDpzcK60MtJoTUaaa1z7I.tzhPHK1.uLJXswe7N.yMxuD8xCi70Nzo
 YEI8yHc.sFhVgY_Q7ruw.5WKxJDb2R1JG.8K1kHO969B9d72Y_T.2hjPTvzI
 i5fvfpF_IYafFB3S0QundySPVmjumxz.1rWek6Q2PoeqCOTKnlHKP8.nhkAs
 DkjQkU7Q_Cf5_ANPJvSJMyhKh.ukAbQO2AqsTf3D3RMuMhiIpiQCXe3rR8oX
 P35APuHtv3kETW73IFmV0iIE6K.QanU_StFBNDQnNB1P7H2Wo9abyAIoKDv0
 Ig_RnNQ_1
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>,
        "Robert W. Love" <robert.w.love@intel.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Bugfixes for .39-rc7
Date: Fri,  6 May 2011 19:54:55 -0700
Message-Id: <1304736898-10830-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

My apologies for lateness with this bugfix series.  This series contains
three patches that should be considered critical target core bugfixes for
.39 that have been under stress testing in a couple of different labs
recently using lio-core-2.6.git/lio-4.1 (.39-rcX) and /lio-4.0 (.38.3)
branch code.

These are all important bugfixes that are required to run with in-flight
.40 HW target drivers in the upstream LIO tree.  This includes fixes for
the main transport_do_task_sg_chain() Data I/O mapping logic, and
task->task_sg[] shutdown path from MSI-X interrupt context.  These patches
apply for all of the following fabric drivers:

   tcm_fc(openfcoe) w/ ddp offload, tcm_qla2xxx, ib_srpt and ibmvscsis.

These patches address issues that are able to easily produce OOPsen with
small backstore max_sectors values, so please review+consider for .39 and
also queue into stable@kernel.org for .38.

The series is also available here for a direct pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-rc-fixes

and has been made against the following scsi-rc-fixes HEAD:

commit c055f5b2614b4f758ae6cc86733f31fa4c2c5844
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Sun May 1 09:42:07 2011 -0500

    [SCSI] fix oops in scsi_run_queue()

Thanks!

--nab

Nicholas Bellinger (3):
  target: Fix multi task->task_sg[] chaining logic bug
  target: Fix interrupt context bug with stats_lock and
    core_tmr_alloc_req
  target: Fix bug with task_sg chained transport_free_dev_tasks release

 drivers/target/target_core_device.c    |    4 +-
 drivers/target/target_core_tmr.c       |    7 +++--
 drivers/target/target_core_transport.c |   39 ++++++++++++++++++++++---------
 include/target/target_core_base.h      |    1 +
 include/target/target_core_transport.h |    1 +
 5 files changed, 35 insertions(+), 17 deletions(-)

-- 
1.7.5.1

