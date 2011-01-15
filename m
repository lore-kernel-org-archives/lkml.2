Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1AOXWm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:22:42 -0500
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:33725 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754079Ab1AOXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:22:41 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Jan 2011 18:22:41 EST
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: IXrlyUgVM1k95q4_cmKQjOQq7_kZdqXsS1.qofYrfqoaBR7
 sfKvToTK70j28_k6OSbqwKm1MT2GDSIzsBf3D7djn.f0Yev0hzzkqbTA9oq2
 jkmn2.EcrFchH66a2QlhNeGHLpmrBosIoNobCM9XJT87009D5m87Y4648JHQ
 iynP6LbcDHsrJwu2kSxD3_ntsbEFZqYZDBQIRkVW1kCqa0eyiwSbNX1T9Gw8
 Q6_RogeUhcybyVUrA7kVp4bzDQ2HtR.Iyiusc0QXQgZMn9H0iL2WgJWFBO5e
 JHbZSkyAydxHLE.wzyF1F8ex0d9WqT_sOESs-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH] Fix CONFIGFS_FS -> select SYSFS recursive dependencies
Date: Sat, 15 Jan 2011 15:16:07 -0800
Message-Id: <1295133371-25990-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi again Linus,

Along with the jlbec ACK'ed CONFIGFS_FS -> select SYSFS patch for .38-rc1
sent earlier today here:

configfs: change depends -> select SYSFS
http://marc.info/?l=linux-scsi&m=129512586329785&w=2

the following patches are required to correct three additional recursive
dependencies for CONFIGFS_FS -> select SYSFS found during this afternoon's
lio-core-2.6.git/linus-38-rc1 defconfig build.  These appear to be straight
forward enough changes to merge..

Joel & Randy, are these OK with you..?

Thanks,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@suse.de>

Nicholas Bellinger (3):
  net: Make NETCONSOLE_DYNAMIC depend on CONFIGFS_FS
  dlm: Make DLM depend on CONFIGFS_FS
  ocfs2: Make OCFS2_FS depend on CONFIGFS_FS

 drivers/net/Kconfig |    3 +--
 fs/dlm/Kconfig      |    3 +--
 fs/ocfs2/Kconfig    |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

