Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab1ELHHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:07:35 -0400
Received: from nm2.access.bullet.mail.sp2.yahoo.com ([98.139.44.129]:46599
	"HELO nm2.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751202Ab1ELHHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:07:33 -0400
X-Yahoo-Newman-Id: 583571.49014.bm@omp1019.access.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Woyjw4oVM1mS4glxmdBv5hIWt0z8Am2Cy0DFQI10osSgrZu
 Asj9ZDFzd1CA61.J0vey0K1RxI8ZecB4ENb0LlkOnpopejMB_K7T.0ZBTjKv
 6ZPhjWo4J9usHXYZ.xtLwQV9CG7uqcVY1qdFdus7TIpGPr4mN2aQJPPNQOVc
 Ro1siQHb3EKhw._NpwW07krYfXxYOgS9tTRV7awn04vzGnMHUqvXny0tIUhd
 H9Of5mAOtaK8kSfFm2dKTT4H8odVpYWB_Rk349aqNimZZR0CqNWnE_98mmPM
 sx5SF.WabWTAckZVGaLiEt9IVDSXFPi_F5PdP9P_dWcyLejkhOXpBc4juRp4
 8lcVb9CxjHcmdPfrLUj_O6Ax8ttRjDzcZ06KUH.L_bEyB3Gpj2UsHH.TZ1UU
 JH6JhKURwXL1GhimzIMmSS6LdZJQyQGXGIDFCXj.CVnYn09dbAUA4jkdU2Q5
 o9nkmACzapX755O4uCtfmWwdiUvLusYBn.V_1VX904zyabflB1G_V6DoL4ZX
 uPGHhAvtmhxR4FCknfqsfJOZdGF6wCxI.OJmxdq9j5u8E41PhSHPHsu..
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v3 00/14] iscsi-target: initial .40 drivers/target/iscsi merge
Date: Thu, 12 May 2011 00:07:07 -0700
Message-Id: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hello upstream kernel folks,

Here is an updated v3 mergeable + squashable version of iscsi-target based
upon Mike Christie's most recent feedback, Martin Svec's testing and OOPs
bugfixes, and Andy Grover's LIO upstream v4.1 based drivers/target/ cleanups
rebased to .39-rc7 mainline code.

This patch series is made against the following linux-2.6.git commit:

commit 693d92a1bbc9e42681c42ed190bd42b636ca876f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon May 9 19:33:54 2011 -0700

    Linux 2.6.39-rc7

Please merge patch #1 + #2 as a seperate iscsi commits after Mike's review
and signoff.  Patch #3 is a seperate target_core int_to_scsilun() conversion
patch so we can drop target_core_fabric_ops->pack_lun() for the initial merge
of iscsi-target.

>From there squash #4 -> #14 using the commit message message of patch #4 for
an initial commit for iscsi-target.

The complete series is also available directly from git here:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-40-iscsi-target-merge

I will follow with any further comments from Christoph, Mike & Co for an
initial .40 merge against mainline target infrastructure.

A petabyte sized thank you to everyone who has contributed to the iscsi-target
.40 mainline effort! 

--nab

Nicholas Bellinger (14):
  iscsi: Resolve iscsi_proto.h naming conflicts with
    drivers/target/iscsi
  iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
  target: Convert REPORT_LUNs to use int_to_scsilun
  iscsi-target: Add iSCSI fabric support for target v4
  iscsi-target: Add TCM v4 compatiable ConfigFS control plane
  iscsi-target: Add configfs fabric dependent statistics
  iscsi-target: Add TPG and Device logic
  iscsi-target: Add iSCSI Login Negotiation + Parameter logic
  iscsi-target: Add CHAP Authentication support using libcrypto
  iscsi-target: Add Sequence/PDU list + DataIN response logic
  iscsi-target: Add iSCSI Error Recovery Hierarchy support
  iscsi-target: Add support for task management operations
  iscsi-target: Add misc utility and debug logic
  iscsi-target: Add Makefile/Kconfig and update TCM top level

 drivers/infiniband/ulp/iser/iser_initiator.c      |    2 +-
 drivers/scsi/be2iscsi/be_main.h                   |    4 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                    |    8 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                  |    2 +-
 drivers/scsi/libiscsi.c                           |   22 +-
 drivers/target/Kconfig                            |    1 +
 drivers/target/Makefile                           |    1 +
 drivers/target/iscsi/Kconfig                      |   18 +
 drivers/target/iscsi/Makefile                     |   20 +
 drivers/target/iscsi/iscsi_target.c               | 4962 +++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.h               |   42 +
 drivers/target/iscsi/iscsi_target_auth.c          |  496 ++
 drivers/target/iscsi/iscsi_target_auth.h          |   31 +
 drivers/target/iscsi/iscsi_target_configfs.c      | 1925 ++++++++
 drivers/target/iscsi/iscsi_target_configfs.h      |    7 +
 drivers/target/iscsi/iscsi_target_core.h          |  859 ++++
 drivers/target/iscsi/iscsi_target_datain_values.c |  533 +++
 drivers/target/iscsi/iscsi_target_datain_values.h |   12 +
 drivers/target/iscsi/iscsi_target_debug.h         |  113 +
 drivers/target/iscsi/iscsi_target_device.c        |   88 +
 drivers/target/iscsi/iscsi_target_device.h        |    9 +
 drivers/target/iscsi/iscsi_target_erl0.c          | 1005 +++++
 drivers/target/iscsi/iscsi_target_erl0.h          |   15 +
 drivers/target/iscsi/iscsi_target_erl1.c          | 1303 ++++++
 drivers/target/iscsi/iscsi_target_erl1.h          |   26 +
 drivers/target/iscsi/iscsi_target_erl2.c          |  481 ++
 drivers/target/iscsi/iscsi_target_erl2.h          |   18 +
 drivers/target/iscsi/iscsi_target_login.c         | 1227 +++++
 drivers/target/iscsi/iscsi_target_login.h         |   12 +
 drivers/target/iscsi/iscsi_target_nego.c          | 1068 +++++
 drivers/target/iscsi/iscsi_target_nego.h          |   17 +
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |  264 ++
 drivers/target/iscsi/iscsi_target_nodeattrib.h    |   14 +
 drivers/target/iscsi/iscsi_target_parameters.c    | 1910 ++++++++
 drivers/target/iscsi/iscsi_target_parameters.h    |  269 ++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  665 +++
 drivers/target/iscsi/iscsi_target_seq_pdu_list.h  |   86 +
 drivers/target/iscsi/iscsi_target_stat.c          |  950 ++++
 drivers/target/iscsi/iscsi_target_stat.h          |   64 +
 drivers/target/iscsi/iscsi_target_tmr.c           |  850 ++++
 drivers/target/iscsi/iscsi_target_tmr.h           |   14 +
 drivers/target/iscsi/iscsi_target_tpg.c           |  760 ++++
 drivers/target/iscsi/iscsi_target_tpg.h           |   41 +
 drivers/target/iscsi/iscsi_target_tq.c            |  552 +++
 drivers/target/iscsi/iscsi_target_tq.h            |   89 +
 drivers/target/iscsi/iscsi_target_util.c          | 1890 ++++++++
 drivers/target/iscsi/iscsi_target_util.h          |   98 +
 drivers/target/target_core_configfs.c             |    4 -
 drivers/target/target_core_device.c               |   26 +-
 include/scsi/iscsi_proto.h                        |   68 +-
 50 files changed, 22881 insertions(+), 60 deletions(-)
 create mode 100644 drivers/target/iscsi/Kconfig
 create mode 100644 drivers/target/iscsi/Makefile
 create mode 100644 drivers/target/iscsi/iscsi_target.c
 create mode 100644 drivers/target/iscsi/iscsi_target.h
 create mode 100644 drivers/target/iscsi/iscsi_target_auth.c
 create mode 100644 drivers/target/iscsi/iscsi_target_auth.h
 create mode 100644 drivers/target/iscsi/iscsi_target_configfs.c
 create mode 100644 drivers/target/iscsi/iscsi_target_configfs.h
 create mode 100644 drivers/target/iscsi/iscsi_target_core.h
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.c
 create mode 100644 drivers/target/iscsi/iscsi_target_datain_values.h
 create mode 100644 drivers/target/iscsi/iscsi_target_debug.h
 create mode 100644 drivers/target/iscsi/iscsi_target_device.c
 create mode 100644 drivers/target/iscsi/iscsi_target_device.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl0.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl0.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl1.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl1.h
 create mode 100644 drivers/target/iscsi/iscsi_target_erl2.c
 create mode 100644 drivers/target/iscsi/iscsi_target_erl2.h
 create mode 100644 drivers/target/iscsi/iscsi_target_login.c
 create mode 100644 drivers/target/iscsi/iscsi_target_login.h
 create mode 100644 drivers/target/iscsi/iscsi_target_nego.c
 create mode 100644 drivers/target/iscsi/iscsi_target_nego.h
 create mode 100644 drivers/target/iscsi/iscsi_target_nodeattrib.c
 create mode 100644 drivers/target/iscsi/iscsi_target_nodeattrib.h
 create mode 100644 drivers/target/iscsi/iscsi_target_parameters.c
 create mode 100644 drivers/target/iscsi/iscsi_target_parameters.h
 create mode 100644 drivers/target/iscsi/iscsi_target_seq_pdu_list.c
 create mode 100644 drivers/target/iscsi/iscsi_target_seq_pdu_list.h
 create mode 100644 drivers/target/iscsi/iscsi_target_stat.c
 create mode 100644 drivers/target/iscsi/iscsi_target_stat.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tmr.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tmr.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tpg.h
 create mode 100644 drivers/target/iscsi/iscsi_target_tq.c
 create mode 100644 drivers/target/iscsi/iscsi_target_tq.h
 create mode 100644 drivers/target/iscsi/iscsi_target_util.c
 create mode 100644 drivers/target/iscsi/iscsi_target_util.h

-- 
1.7.5.1

