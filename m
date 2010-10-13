Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0JMIru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 04:47:50 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:20117 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753293Ab0JMIrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 04:47:48 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: JmDk7_UVM1kJFiMVQ4MytTWO6vQLTWKehpAAr0VQIlPExQM
 i4JLkawP7TdPIi8LNZM.3aE9_5kxa_F3OmtxYygzMbQqt21ueJLPm4hpjJfW
 gQDTrF.a8bdk1oTYgcHUqs2bfb9gy01Clu5DuzFLCuVadW5fqd1scF1sRc.1
 5FEx4xDXzf7xqP3_doJvUOyzvujzeeQCU2AIuSvJQKLPja_VHm4piJ9VQcAl
 5OGXrt2AvPrvgljdK7xDCd_7Kf733MnDKRl_jXLa5Zvpe7BjQpebPPpCKCkn
 r6D_eiAAWh4FW.VhCaxnOJBWv3.YX2h7JImDhjvPxJmh4_TOteIZzo9.D5bX
 mXcd28KokdYq115kESA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/5] tcm: Unify subsystem plugin control CDB emulation
Date: Wed, 13 Oct 2010 01:47:43 -0700
Message-Id: <1286959663-3402-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This patch series pushes the remaining SPC-3 control path CDB emualation for
INQUIRY, READ_CAPACITY_*, UNMAP and WRITE_SAME w/ UNMAP=1, and SYNCHRONIZE_CACHE_*
subsystem plugin handling into generic TCM code.

It follows Christoph's recommendation to pick off the non SCF_SCSI_DATA_SG_IO_CDB
struct se_tasks before hitting struct se_subsysem_api->do_task(), and removal of
struct se_subsystem_api_cdb initially added in commit 3712c6da407.

So far this has been tested with TCM/IBLOCK and TCM/FILEIO subsystem plugins on
v2.6.36-rc7 x86 HVM with sg_inquiry, sg_readcap, sg_unmap, sg_write_same -[ST] -U,
and sg_sync.

Thanks again go out to hch for pushing for IBLOCK and FILEIO to become drivers/scsi
independent and save yet another ~80 LOC from the v4.0 tree!  Thanks Christoph!!!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (5):
  tcm: Move transport_emulate_control_cdb() into
    __transport_execute_tasks()
  tcm: Unify INQUIRY subsystem plugin handling
  tcm: Unify READ_CAPACITY_* subsystem plugin handling
  tcm: Unify UNMAP and WRITE_SAME w/ UNMAP=1 subsystem plugin handling
  tcm: Unify SYNCHRONIZE_CACHE_* subsystem plugin handling

 drivers/target/target_core_file.c      |  101 +++++++++++------------------
 drivers/target/target_core_iblock.c    |  113 ++++++++++++--------------------
 drivers/target/target_core_rd.c        |   89 ++++++++-----------------
 drivers/target/target_core_transport.c |  111 ++++++++++++++++---------------
 include/target/target_core_transport.h |   48 ++++++++------
 5 files changed, 193 insertions(+), 269 deletions(-)

