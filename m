Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1B1GU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:20:26 -0500
Received: from nm10-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.72]:42972 "HELO
	nm10-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750802Ab1B1GUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:20:24 -0500
X-Yahoo-Newman-Id: 253241.68545.bm@omp1038.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: y0F6R8oVM1kwlHUMj.NYrnDebEB9WsxC2p0rIUm1fmUYqwk
 cpRcCzgnoRlX91GJ2v3N6g87q3ioTGXbmrLf..9BwpzxMX.W0hVJLXDCX2eP
 gGw5zqaaWc6FzjdIRQeFcq1sJcI2jZapcAUHhMJW6x5pLzPGuSuV4ELFtfCi
 A3TW3w.zhzeMkalI.3aqg.tGdQDtZtF.eypoS20TRHdAQf0lTLr_oXG2rde_
 o._M0pEH2jyIgvT5G7lDHArImfx4m2Vh0BC_UPgWd_09h5wVm60J5HwRgR2I
 fBXg1kPf4tXsDS7gtWi4Nc9Agt.IphWEBPpYP
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Joel Becker <jlbec@evilplan.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/5] target updates for scsi-post-merge .39 (round one)
Date: Sun, 27 Feb 2011 22:20:15 -0800
Message-Id: <1298874020-15628-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

The following is the first round of target patches intended for .39
scsi-post-merge tree that introduces new target functionality and the
first mainline TCM fabric module (TCM_Loop).

Patches #1 -> #4 involve the addition of new ConfigFS context based
statistics groups in target_core_stat.c following RFC-4455 to address
the removal of the legacy ProcFS based target_core_mib.c in .38 code.

Patch #5 adds the TCM_Loop virtual SCSI LLD module that was originally
reviewed and intended for .38 code.  This module currently supports
high level port emulation for SAS, FC and iSCSI ProtoIdents.

Please be sure to apply this series on top the critical 'for-38-urgent'
fix posted here:

[PATCH-FOR-38] target: Fix t_transport_aborted handling in LUN_RESET + active I/O shutdown
http://marc.info/?l=linux-scsi&m=129859551620778&w=2

as well as the 14 patch series for-39-misc-v2 posted recently here:

[PATCH 00/14] target patches for .39 scsi-misc (v2)
http://marc.info/?l=linux-scsi&m=129866341626173&w=2

This full series is also available directly from git here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-post-merge

Please review and apply,

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (5):
  target: add initial device backend context target_core_stat.c code
  target: add initial fabric port context target_core_stat.c code
  target: add initial fabric MappedLUN context target_core_stat.c code
  target: Add fabric_stat_group for fabric module statistics
    default_group
  tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module

 drivers/target/Kconfig                         |    2 +
 drivers/target/Makefile                        |    6 +-
 drivers/target/target_core_configfs.c          |   76 +-
 drivers/target/target_core_fabric_configfs.c   |  209 +++-
 drivers/target/target_core_stat.c              | 1810 ++++++++++++++++++++++++
 drivers/target/target_core_stat.h              |    8 +
 drivers/target/tcm_loop/Kconfig                |   11 +
 drivers/target/tcm_loop/Makefile               |   11 +
 drivers/target/tcm_loop/tcm_loop_configfs.c    |  647 +++++++++
 drivers/target/tcm_loop/tcm_loop_configfs.h    |    2 +
 drivers/target/tcm_loop/tcm_loop_core.h        |   77 +
 drivers/target/tcm_loop/tcm_loop_fabric.c      |  476 +++++++
 drivers/target/tcm_loop/tcm_loop_fabric.h      |   40 +
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  605 ++++++++
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |   10 +
 include/target/target_core_base.h              |   35 +-
 include/target/target_core_configfs.h          |    4 +
 17 files changed, 4011 insertions(+), 18 deletions(-)
 create mode 100644 drivers/target/target_core_stat.c
 create mode 100644 drivers/target/target_core_stat.h
 create mode 100644 drivers/target/tcm_loop/Kconfig
 create mode 100644 drivers/target/tcm_loop/Makefile
 create mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_configfs.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_core.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric.h
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c
 create mode 100644 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h

-- 
1.7.4.1

