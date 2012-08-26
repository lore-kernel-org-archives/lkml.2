Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2HZJFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 05:05:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:13064 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab2HZJE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 05:04:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,315,1344236400"; 
   d="scan'208";a="212423971"
Date: Sun, 26 Aug 2012 17:04:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Anton Altaparmakov <anton@tuxera.com>
Cc: kernel-janitors@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: fs/ntfs/super.c:2717:1-14: alloc with no test
Message-ID: <20120826090447.GA11098@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Anton,

FYI, coccinelle warns about

fs/ntfs/super.c:2717:1-14: alloc with no test, possible model on line 2718

vim +2717 fs/ntfs/super.c
  2714		sb->s_flags |= MS_RDONLY;
  2715	#endif /* ! NTFS_RW */
  2716		/* Allocate a new ntfs_volume and place it in sb->s_fs_info. */
> 2717		sb->s_fs_info = kmalloc(sizeof(ntfs_volume), GFP_NOFS);
  2718		vol = NTFS_SB(sb);
  2719		if (!vol) {
  2720			if (!silent)

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
