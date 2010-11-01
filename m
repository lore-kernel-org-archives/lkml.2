Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0KATpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:45:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41188 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0KATpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:45:50 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk
Subject: [PATCH v1.1 0/5] IMA: making i_readcount a first class inode citizen 
Date: Mon,  1 Nov 2010 15:45:34 -0400
Message-Id: <1288640739-3246-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the previous posting discussion, i_readcount is now defined as
atomic.

This patchset separates the incrementing/decrementing of the i_readcount,
in the VFS layer, from other IMA functionality, by replacing the current
ima_counts_get() call with iget_readcount(). Its unclear whether this
call to increment i_readcount should be made earlier, like i_writecount.

The patch ordering is a bit redundant in order to leave removing the ifdef
around i_readcount until the last patch. The first four patches: redefines 
i_readcount as atomic, defines iget/iput_readcount(), moves the IMA
functionality in ima_counts_get() to ima_file_check(), and removes the IMA
imbalance code, simplifying IMA. The last patch moves iput_readcount()
to the fs directory and removes the ifdef around i_readcount, making
i_readcount into a "first class inode citizen".

The generic_setlease code could then take advantage of i_readcount.
 
Mimi

Mimi Zohar (5):
  IMA: convert i_readcount to atomic
  IMA: define readcount functions
  IMA: maintain i_readcount in the VFS layer
  IMA: remove IMA imbalance checking
  IMA: making i_readcount a first class inode citizen

 fs/file_table.c                   |   16 ++++-
 fs/inode.c                        |    3 +
 fs/open.c                         |    3 +-
 include/linux/fs.h                |    9 ++-
 include/linux/ima.h               |    6 --
 security/integrity/ima/ima_iint.c |    5 --
 security/integrity/ima/ima_main.c |  131 +++++--------------------------------
 7 files changed, 43 insertions(+), 130 deletions(-)

-- 
1.7.2.2

