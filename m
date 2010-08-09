Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab0HIETh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 00:19:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50998 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab0HIETg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 00:19:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=ANKqMmV0hsX692Z6AwWf165PHq59Qdfu7KCosSMLuQu8Hzs4MsLkYmp56P2N2VLKse
         QoqJoxXu0edpi/ZQwFEe3RSU6Z+k0UFjikRLwADSy0Orvy6LZGWKMoNbxdSmk0V3qKNY
         CsjWznpSFsoYxfAqkP6x3igIxiB9DmWXPgK5s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] bkl ioctl pushdowns for 2.6.36
Date: Mon,  9 Aug 2010 06:19:32 +0200
Message-Id: <1281327572-411-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the bkl/ioctl branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/ioctl

There is a merge of a recent version of your master branch inside. This
is because we would like to remove the struct file_operations:ioctl callback
by the end of this merge window. But we missed the new easycap driver
that got merged in staging and which is one of the last that uses the ioctl
callback. 

Usually we would have prefered this pushdown to go through the staging
tree but since I don't know if there will be another staging merge for
this -rc1, I have merged your tree that has this driver and did the
pushdown in my branch.

The rest of the pending bkl ioctl pushdowns are in the
logfs and ecryptfs trees. If everything goes well, we'll propose
a patch to remove ioctl by the end of the merge window.

Thanks,
	Frederic
---

Arnd Bergmann (3):
      ia64/perfmon: Convert to unlocked_ioctl
      v4l: Convert v4l2-dev to unlocked_ioctl
      autofs/autofs4: Move compat_ioctl handling into fs

Frederic Weisbecker (1):
      staging: Pushdown bkl to easycap ioctl handlers

Huang Weiyi (2):
      ncpfs: Remove duplicated #include
      sunrpc: Remove duplicated #include


 drivers/media/video/v4l2-dev.c          |   52 +++++++-----------------
 drivers/staging/easycap/easycap.h       |    8 +---
 drivers/staging/easycap/easycap_ioctl.c |   52 ++++++++++++++----------
 drivers/staging/easycap/easycap_main.c  |   38 +++++++++---------
 fs/autofs/root.c                        |   67 +++++++++++++++++++++++++++++-
 fs/autofs4/root.c                       |   49 ++++++++++++++++++++++
 fs/compat_ioctl.c                       |   36 ----------------
 fs/ncpfs/ioctl.c                        |    1 -
 include/linux/auto_fs.h                 |    1 +
 9 files changed, 180 insertions(+), 124 deletions(-)

