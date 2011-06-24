Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165Ab1FXAhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:37:01 -0400
Received: from nm17.access.bullet.mail.mud.yahoo.com ([66.94.237.218]:29193
	"HELO nm17.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759615Ab1FXAg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:36:59 -0400
X-Yahoo-Newman-Id: 812777.48823.bm@omp1009.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: EDZpl1QVM1knMzzUY6xW7ygLKS1Swb0npxwDep8kV8SBliv
 hbGTBWAmVdvMK5_LDf1JnTdoq1UpJiY.Y2sHTp35oR3KZbLj4aa5HrvZ171G
 EwbHIhFtfXQUwfimd.tIz2QOzLqCmGxd00Ta6wQGzm_bjMcgQJnw9_xBa3qh
 758EqfEUAGu7DZxDfCAyC0iIerxYoqDsIOa2YMo3CXNGIMSWpFbezIRIpgEH
 s_urn_cmQL6_6ut45sEJzHij_siOqLmu8slmku5NEDHgdZUFVpn.30O7daWy
 DbeCgby0GFs5nE095655DXtpOWdKLnvlf5VqLbVx2puUhjm7TeP89aPhtCvi
 dk3W3HFXsBtIXgFZ9yyBe9g_IpbinCX753R2dn0eNAP6w7KS1Rr7N635DzYO
 bPnFzUmqdXu2qLnx_men8ce1tRI8Nf1d1QHqjKBKkUws7hpoBee2AS7AzJc3
 v8PH8_wwoLtwWXlOMDmqULjwBaluLF.7VI1CRgZn0OjOdCub9rtwYKhJstAY
 nH7KjPDlcdu3hxOHAsPcN9sp5iQFjhryE4BbIKaIf.kcfFSK.2Z4Vdgs-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Dan Carpenter <error27@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [GIT PULL] target: Updates for v3.0-rc5
Date: Thu, 23 Jun 2011 17:42:59 -0700
Message-Id: <1308876179-3974-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Linus,

Here are the target updates for v3.0-rc5 that have been marinating in
lio-core-2.6.git for a few weeks now, and are ready for you to pull.

It includes a OOPs bugfix for task management exception handling in target
core, a bugfix for incorrect TMR LUN lookup in tcm_fc fixed by Kiran,
a series from Dan to address issues with ERR_PTR dereferencing + strlen usage +
possible deadlock fix, and Roland's spin_lock_irq() -> irqsave() change
required for certain cases in HW target mode operation in order prevent from
re-enabling interrupts that have already been disabled with a seperate
irqsave() call.

This series has been made against the following HEAD:

commit 56299378726d5f2ba8d3c8cbbd13cb280ba45e4f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Jun 20 20:25:46 2011 -0700

    Linux 3.0-rc4

Please pull go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-linus

Thanks!

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Dan Carpenter (4):
  target: Fix ERR_PTR dereferencing bugs
  target: Drop bogus ERR_PTR usage in target_fabric_configfs_init
  target: Fix incorrect strlen() NULL terminator checks
  tcm_fc: Fix possible lock to unlock type deadlock

Kiran Patil (1):
  tcm_fc: Fix ft_send_tm LUN lookup OOPs

Nicholas Bellinger (2):
  target: Fix transport_get_lun_for_tmr failure cases
  tcm_fc: Fix conversion spec warning

Roland Dreier (1):
  target: Convert transport_deregister_session_configfs nacl_sess_lock
    to save irq state

 drivers/target/loopback/tcm_loop.c     |   13 ++++--
 drivers/target/target_core_configfs.c  |   24 ++++++------
 drivers/target/target_core_device.c    |    5 +-
 drivers/target/target_core_pr.c        |    6 +-
 drivers/target/target_core_tmr.c       |    8 +++-
 drivers/target/target_core_transport.c |    6 +-
 drivers/target/tcm_fc/tcm_fc.h         |    2 +-
 drivers/target/tcm_fc/tfc_cmd.c        |   64 ++++++++++++++++---------------
 drivers/target/tcm_fc/tfc_io.c         |    2 +-
 drivers/target/tcm_fc/tfc_sess.c       |    4 +-
 10 files changed, 73 insertions(+), 61 deletions(-)

-- 
1.7.5.4

