Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab0IVGIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 02:08:41 -0400
Received: from smtp104.sbc.mail.ne1.yahoo.com ([98.138.84.215]:30104 "HELO
	smtp104.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751187Ab0IVGIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 02:08:39 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ucDEVdMVM1lTDsxOpv3hMSmqOLO1nJ6lV1EVs8dK6JGkVcO
 rR6ilMVhvyZTckCig9Pw62DHjPXWmfhSArcRC1WXd1hEzJIcxMpAgQEzfIme
 eOfSTH9gFFkVt1DBbz9XbvmIIekKsZax2PhthehryaxV_i.7hJDUDz8Sck4q
 gioMWmXEzt8qST7rU8ils.CFSqZNPWEGmsYnBBmxET3F.PG5amtdBi1eNljr
 YyLpa6CNmqB0m80.sDU8zTlDQYZTZ7tiR8NNI9O0_.RnAiv72SOheeo5GV4d
 0w8DeEnRGkGxL9iSpcSvLkVJuznzM5J3Lg10j24F6ySgaO8V3YoJR3_6EP5t
 IOED3QWaZ1pvFCA7IiA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm/pscsi: Add support for BIDI-COMMAND passthrough
Date: Tue, 21 Sep 2010 23:08:34 -0700
Message-Id: <1285135714-8308-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Boaz and Co,

This patch series adds proper support to TCM Core for XDWRITEREAD_32 and
XDWRITEREAD_10 to allow for TCM/pSCSI plugin -> SCSI ML via struct request.

This first patch adds the necessary pieces to TCM Core for handling the
transparent memory mapping using the new struct se_task->task_sg_bidi[],
and other necessary bits for the underlying per new se_task BIDI context
into TCM/pSCSI.

The second patch adds support in TCM/pSCSI plugin code to handle the
extra struct request allocation, setup and release for the additional
BIDI SCSI READ SCSI READ payload going into struct se_task->task_sg_bidi[]
memory.

And the third patch adds the same passthrough option as above with TCM/pSCSI
for XDWRITEREAD_10 CDBs in TCM Core.

So far this has been tested with TCM_Loop -> TCM_core -> TCM/pSCSI ->
scsi_debug on v2.6.36-rc4 in x86 HVM.

Many thanks to Boaz for his comments with BIDI-COMMANDs and > 16 byte CDBs!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm: Add support for BIDI-COMMAND passthrough
  tcm/pscsi: Add proper BIDI-COMMAND passthrough to SCSI MidLayer
  tcm: Add XDWRITEREAD_10 passthrough support

 drivers/target/target_core_pscsi.c     |  111 ++++++++++++++++++++++++-------
 drivers/target/target_core_pscsi.h     |    1 +
 drivers/target/target_core_transport.c |  112 ++++++++++++++++++++++++++++----
 include/target/target_core_base.h      |    1 +
 4 files changed, 185 insertions(+), 40 deletions(-)

