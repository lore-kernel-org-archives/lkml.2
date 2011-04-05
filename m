Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1DEFME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 01:12:04 -0400
Received: from nm20-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.45]:29788 "HELO
	nm20-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751613Ab1DEFMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 01:12:03 -0400
X-Yahoo-Newman-Id: 517077.51534.bm@omp1001.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: mJ3IbDgVM1mtdrUHpV.Sby55JZXyezj_74h.aVk8WxXPypA
 LiKxH5q74_gaZe993fiQi9MmoMJAexvnUanhA3lcSG5U6Y..a7CJyUP0Fp49
 NgD1EBaeU5lOhHozKzxdtdoTeZbyZRYoSFh.rlkY3aYcGuXcGAP.kRBfUNAw
 68bIS2NE3hVLkKMW1l9PK_xBwKYRPVvJoBEBR6NqtsbfPkXmWgVKodIpy1We
 ITz7dQsKTpOeVRRUn2S5IZ9kn20dts2oVlNfh2TJLZmxIUxBKQjNQyKedZsK
 Z0iUIrGL6I7BvSSFUcQfzgYD93hvQSCMbIC_P4p.Wc7NmvAhNIAnYcuRVvZa
 X2XfhST1dATGxyW.FT63oh6Mq_0rg6ftsWEPbqpMt8t37WQ--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: Madhu Iyengar <madhu.iyengar@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Ruediger Oertel <ro@suse.de>, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC-v3 0/3] qla2xxx LLD target mode + tcm_qla2xxx fabric module
Date: Mon,  4 Apr 2011 22:11:44 -0700
Message-Id: <1301980307-14778-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings James, Christoph, Hannes, and Co,

Attached is the third RFC series for adding qla2xxx LLD target mode support
into mainline v8.03.07.00 @ .39-rc1, along with the accompanying tcm_qla2xxx.ko
fabric module cut against mainline target v4.0 infrastructure.  This series has
been broken up into reviewable sections and should be considered a 'for-40' item.

Many thanks to Andrew Vasquez for his initial off-list review of RFC-v2.
This updated series contains a number of cleanups + removal of unnecessary
code recommended by Andrew for enabling target mode support, and other
misc code maintainibility improvements.

So at this point with the functioning code, we would like to come to a
consensus with linux-scsi folks about how the explict qla2xxx target mode LLD
and tcm_qla2xxx fabric module 'split' should look, and how it will be accepted
into distros and maintained for mainline moving forward.  The Qlogic folks
(Madhu and Andrew) have expressed interest that they would like to eventually
own maintainence for the target pieces inside of qla2xxx, but this currently
ends up being decent chunk of code in qla_target.c that may otherwise better
reside in tcm_qla2xxx code.

So that said, I would really like to get opinions from Christoph, Hannes,
and Mike about how the 'existing LLD / tcm_fabric.ko split' can best done
for mainline, and some input from kernel distro folks would also be useful
here.  Comments here please upstream linux-scsi folks..?

An overview of the current status, todo list, mini-howto and running layout
from /sys/kernel/config/target/qla2xxx/ are available here:

http://www.linux-iscsi.org/index.php/Qlogic
http://www.linux-iscsi.org/wiki/QLogic/configFS

The next major item will be proper target mode NPIV support for >= 24xx series
adapters using the included qla2xxx_npiv fabric skeleton, and which will be
enabled in the next round of review in RFC-v4.

Thanks!

--nab

Nicholas Bellinger (3):
  qla2xxx: Add target mode support into 2xxx series LLD code
  qla2xxx: Enable 2xxx series LLD target mode support
  tcm_qla2xxx: Add HW target mode I/O, control and TMR path code

 drivers/scsi/qla2xxx/Makefile                     |    4 +-
 drivers/scsi/qla2xxx/qla_attr.c                   |    5 +-
 drivers/scsi/qla2xxx/qla_dbg.h                    |   34 +
 drivers/scsi/qla2xxx/qla_def.h                    |   63 +-
 drivers/scsi/qla2xxx/qla_gbl.h                    |    7 +
 drivers/scsi/qla2xxx/qla_gs.c                     |    4 +-
 drivers/scsi/qla2xxx/qla_init.c                   |   79 +-
 drivers/scsi/qla2xxx/qla_iocb.c                   |  105 +-
 drivers/scsi/qla2xxx/qla_isr.c                    |   83 +-
 drivers/scsi/qla2xxx/qla_mbx.c                    |  122 +-
 drivers/scsi/qla2xxx/qla_mid.c                    |   21 +-
 drivers/scsi/qla2xxx/qla_os.c                     |  107 +-
 drivers/scsi/qla2xxx/qla_target.c                 | 5556 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.h                 | 1137 +++++
 drivers/target/Kconfig                            |    1 +
 drivers/target/Makefile                           |    1 +
 drivers/target/tcm_qla2xxx/Kconfig                |    7 +
 drivers/target/tcm_qla2xxx/Makefile               |    6 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |  102 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c | 1439 ++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |  853 ++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h   |   53 +
 22 files changed, 9750 insertions(+), 39 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_target.c
 create mode 100644 drivers/scsi/qla2xxx/qla_target.h
 create mode 100644 drivers/target/tcm_qla2xxx/Kconfig
 create mode 100644 drivers/target/tcm_qla2xxx/Makefile
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h

-- 
1.7.4.3

