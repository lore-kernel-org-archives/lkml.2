Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1BNUaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:30:24 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46470 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab1BNUaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:30:21 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>, torvalds@linux-foundation.org,
        eparis@redhat.com, viro@zeniv.linux.org.uk,
        Dave Chinner <david@fromorbit.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        David Safford <safford@watson.ibm.com>
Subject: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
Date: Mon, 14 Feb 2011 15:29:53 -0500
Message-Id: <1297715397-4141-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.4
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a repost of patches 1 - 4 of the ima-i_readcount patch set rebased
against security-testing/#next, as requested a while ago.  The patches are
also available from:
git://git.kernel.org/pub/scm/linux/kernel/git/zohar/ima-2.6.git/#next

This patchset separates the incrementing/decrementing of the i_readcount,
in the VFS layer, from other IMA functionality, by replacing the current
ima_counts_get() call with i_readcount_inc(). Its unclear whether this
call to increment i_readcount should be made earlier, like i_writecount.
Currently the call is situated immediately after the switch from put_filp()
to fput() for cleanup.

Mimi

Mimi Zohar (4):
  IMA: convert i_readcount to atomic
  IMA: define readcount functions
  IMA: maintain i_readcount in the VFS layer
  IMA: remove IMA imbalance checking

 fs/file_table.c                   |    5 +-
 fs/open.c                         |    3 +-
 include/linux/fs.h                |   23 ++++++-
 include/linux/ima.h               |    6 --
 security/integrity/ima/ima_iint.c |    5 --
 security/integrity/ima/ima_main.c |  130 ++++---------------------------------
 6 files changed, 40 insertions(+), 132 deletions(-)

-- 
1.7.3.4

