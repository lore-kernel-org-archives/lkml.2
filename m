Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0HSWM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 18:12:58 -0400
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:43662 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752992Ab0HSWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 18:12:56 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: INjN8KsVM1lqNbi3zTI.kjaRX.RlbLapTyxzSuvKukGe9Z7
 x7T5bRKWUl2D1a0imi_tl0p1fxUQP5GsCusQcrHephOX_GiycOnviue17l_P
 fmwYiN_qTWKmz5tsKC.MnthKPs6yvHN9Wnw7MJF0ngDHZYID9ZYDbu4BWV9a
 YkR2b_sROmlTUNalWxDWndYDwPut0HRaqv0X5TkNyNNogoKouP_lbh48yG89
 s_ju9R.4BL8l1tXB3515l3BQDqWYe2H2KNB1d15DWPJt3TGQ..RUseJqd0Ha
 FNr1W9LoJ7Jp_dSud78hC2uaxdKAYN2JwJCARXudMQbkTlwiuXqNoRGdlxN6
 1Rj5DohMv8A--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm: More cleanups for v4.0.0-rc3
Date: Thu, 19 Aug 2010 15:12:52 -0700
Message-Id: <1282255972-12850-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

Here are few more TCM cleanups that are being pushed to lio-core-2.6.git/lio-4.0.

Patch #1 removes an unused struct se_mem -> struct se_mem w/ task_offset
mapping function, patch #2 was recommended by hch now that se_obj_lun_type_t
no longer exists, and patch #3 removes legacy usage of type 'void *' for
struct se_lun->lun_type_ptr, and instead uses a easily grokable struct se_lun->lun_se_dev
member for existing all struct se_lun -> struct se_device references.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm: Remove legacy transport_map_mem_to_mem()
  tcm: Remove remaining code out of target_core_seobj.c
  tcm: Remove legacy struct se_lun->lun_type_ptr

 drivers/target/Kbuild                        |    1 -
 drivers/target/lio-target/iscsi_target_mib.c |    8 +-
 drivers/target/target_core_alua.c            |    6 +-
 drivers/target/target_core_configfs.c        |    1 -
 drivers/target/target_core_device.c          |   86 +++++-
 drivers/target/target_core_fabric_configfs.c |    3 +-
 drivers/target/target_core_mib.c             |    8 +-
 drivers/target/target_core_seobj.c           |  214 ---------------
 drivers/target/target_core_seobj.h           |   47 ----
 drivers/target/target_core_tpg.c             |   15 +-
 drivers/target/target_core_transport.c       |  379 +++++++++++++-------------
 include/target/target_core_base.h            |    5 +-
 include/target/target_core_device.h          |    6 +
 include/target/target_core_transport.h       |   11 +-
 14 files changed, 286 insertions(+), 504 deletions(-)
 delete mode 100644 drivers/target/target_core_seobj.c
 delete mode 100644 drivers/target/target_core_seobj.h

