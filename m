Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2FNXXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:23:14 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:45219 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2FNXXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:23:13 -0400
Subject: [GIT PULL] target rc-fixes for v3.5-rc3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>,
        =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jun 2012 16:23:09 -0700
Message-ID: <1339716189.12064.96.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus!

Here is the outstanding series of target 3.5-rc-fixes currently pending
for v3.5-rc3 merge.  As mentioned in the tree work-flow re-org
announcement, target bug-fixes slated for the current release will now
be coming via branch master following Linux/KVM's tree workflow.

The branch master is based upon:

commit cfaf025112d3856637ff34a767ef785ef5cf2ca9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jun 8 18:40:09 2012 -0700

    Linux 3.5-rc2

Please go ahead and pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This series contains post merge qla_target.c / tcm_qla2xxx bugfixes from
the past weeks, including the patch to allow target-core to use an
optional session shutdown callback to help address an active I/O
shutdown bug in tcm_qla2xxx code (Joern).

Also included is a target regression bugfix releated to explict ALUA
target port group CDB emulation that is CC'ed to stable (Roland).

Thank you!

--nab

Joern Engel (2):
  target: Add TFO->put_session() caller for HW fabric session shutdown
  tcm_qla2xxx: Convert to TFO->put_session() usage

Nicholas Bellinger (1):
  tcm_qla2xxx: Clear session s_id + loop_id earlier during shutdown

Roland Dreier (6):
  target: Return error to initiator if SET TARGET PORT GROUPS emulation
    fails
  tcm_qla2xxx: Don't insert nacls without sessions into the btree
  qla2xxx: Don't crash if we can't find cmd for failed CTIO
  qla2xxx: Don't leak commands we give up on in qlt_do_work()
  tcm_qla2xxx: tcm_qla2xxx_handle_tmr() can be static
  tcm_qla2xxx: Handle malformed wwn strings properly

Sachin Kamat (1):
  qla2xxx: Remove version.h header file inclusion

 drivers/scsi/qla2xxx/qla_target.c      |   11 +--
 drivers/scsi/qla2xxx/qla_target.h      |    1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  152 ++++++++++++--------------------
 drivers/target/target_core_alua.c      |    5 +-
 drivers/target/target_core_transport.c |    8 ++-
 include/target/target_core_fabric.h    |    1 +
 6 files changed, 74 insertions(+), 104 deletions(-)


