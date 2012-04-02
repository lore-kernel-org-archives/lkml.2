Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2DBLpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:45:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:58478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab2DBLpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:45:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="124444277"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Ted Tso <tytso@mit.edu>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v2 0/4] do not use s_dirt in ext4
Date: Mon,  2 Apr 2012 14:45:35 +0300
Message-Id: <1333367140-28370-1-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set makes ext4 independent of the VFS superblock management
services. Namely, ext4 does not require to register the 'write_super()' VFS
call-back.

The reason of this exercises is to get rid of the 'sync_supers()' kernel thread
which wakes up every 5 seconds (by default) even if all superblocks are clean.
This is wasteful from power management POW (unnecessary wake-ups).

Version 1 of this patch-set can be found here:
https://lkml.org/lkml/2012/3/20/220

Changes between v1 and v2.
  * Rake different strategy - instead of pushing 's_dirt' down "as-is" and
    emulating old behavior, we now just submit the superblock for writing
    straight away, either via the journal or directly. Thank to Jan Kara
    for helping with this.
  * Ted picked some of the patches already, which made this series shorter
    - thanks!
  * This time I've tested the changes using xfstests.
  * Rebased to 3.4-rc1.

Note: Ted, you merged the "mm: export dirty_writeback_interval", but it looks
like we won't need this for ext[23]. However, for other file-systems we will
need this change.

Thanks,
Artem.
