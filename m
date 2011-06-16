Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1FPAHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 20:07:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:51347 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab1FPAHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 20:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,372,1304319600"; 
   d="scan'208";a="15334915"
Date: Wed, 15 Jun 2011 17:05:46 -0700
From: Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: WARNING: at /home/ak/lsrc/git/linux-2.6/fs/fs-writeback.c:356
Message-ID: <20110616000546.GA15121@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just got this shortly after booting a fresh Linus kernel on a 16 thread
system. I had some patches on top, but they were completely unrelated.

------------[ cut here ]------------
WARNING: at /home/ak/lsrc/git/linux-2.6/fs/fs-writeback.c:356 writeback_single_inode+0x65/0x1b7()
Modules linked in:
Pid: 3597, comm: flush-8:0 Not tainted 3.0.0-rc3-00061-g522a899 #164
Call Trace:
 [<ffffffff81039919>] warn_slowpath_common+0x85/0x9d
 [<ffffffff8103994b>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff810ff887>] writeback_single_inode+0x65/0x1b7
 [<ffffffff810ffbe5>] writeback_sb_inodes+0xba/0x134
 [<ffffffff81100592>] writeback_inodes_wb+0x16f/0x181
 [<ffffffff8110080f>] wb_writeback+0x26b/0x3a7
 [<ffffffff81100a92>] wb_do_writeback+0x147/0x1a0
 [<ffffffff81100b77>] bdi_writeback_thread+0x8c/0x20f
 [<ffffffff81100aeb>] ? wb_do_writeback+0x1a0/0x1a0
 [<ffffffff81100aeb>] ? wb_do_writeback+0x1a0/0x1a0
 [<ffffffff81053f11>] kthread+0x82/0x8a
 [<ffffffff815e78d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81053e8f>] ? kthread_worker_fn+0x13a/0x13a
 [<ffffffff815e78d0>] ? gs_change+0xb/0xb
---[ end trace fc0a60eb73c3e138 ]---

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
