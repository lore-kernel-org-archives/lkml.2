Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1A0TK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:10:29 -0500
Received: from nm3.bullet.mail.ne1.yahoo.com ([98.138.90.66]:45732 "HELO
	nm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753072Ab1A0TK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:10:27 -0500
X-Yahoo-Newman-Id: 562049.38727.bm@omp1036.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: gAU_.hcVM1lmxIsnaaKgXaToxwYRrqh5rZNXAuS7TlDXRPE
 _TNHAhkRg3OB05rRZhX2Xrt8rYltQZTw3ta7p6J3xsW3riQXWh0QeJPFoaeY
 yJgX0TRj4wJC3Gn7yC9BVur_oAG3ydB5VzrGkAHMc7D6D9pvdfTIYOjWLOou
 BLWgS8evK0Wx6T4jsmg0uZLguuLyyj9rgJukxPNxJ9ibxa97PtJfxMIVEYo6
 ClJHT_cMThPSoVG9o8pfvHhB0FHtlEQr4COT6Ife_JkSH07sjnp4LFx.FhgW
 kSOgL9EKU314eRW3Zh850nJ8x5jXUTIe4CtP9McCIqYrPdxJC4Chixe2ytz6
 lniWIgw.jGsFh6Ra1LDsgQT1wFN9zNMd3GIf0n1c-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Joel Becker <jlbec@evilplan.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH RESEND 0/4] Fix kconfig breakage wrt to CONFIGFS_FS
Date: Thu, 27 Jan 2011 11:10:26 -0800
Message-Id: <1296155430-3796-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Linus,

The following four patches are to address recent Kconfig CONFIGFS_FS ->
'select SYSFS' change for GFS2_FS, and 'depends && SYSFS && CONFIGFS_FS'
breakage for NETCONSOLE_DYNAMIC, DLM, and OCFS2_FS in .38-rc2.

Please review and consider pulling from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-linus-v2

currently against the latest linux-2.6.git/master HEAD:

  commit 6fb1b304255efc5c4c93874ac8c066272e257e28
  Merge: ac751ef 409550f
  Author: Linus Torvalds <torvalds@linux-foundation.org>
  Date:   Wed Jan 26 16:31:44 2011 +1000

      Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input

Thanks,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (4):
  gfs2: Remove 'select SYSFS ...' from Kconfig
  net: Make NETCONSOLE_DYNAMIC use select CONFIGFS_FS
  dlm: Make DLM use select CONFIGFS_FS
  ocfs2: Make OCFS2_FS use select CONFIGFS_FS

 drivers/net/Kconfig |    3 ++-
 fs/dlm/Kconfig      |    4 ++--
 fs/gfs2/Kconfig     |    1 -
 fs/ocfs2/Kconfig    |    3 ++-
 4 files changed, 6 insertions(+), 5 deletions(-)

-- 
1.7.3.5

