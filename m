Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935336Ab1IOXHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:07:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:47940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935277Ab1IOXHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:07:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,390,1312182000"; 
   d="scan'208";a="54225744"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Improve lseek scalability v3
Date: Thu, 15 Sep 2011 16:06:46 -0700
Message-Id: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently generic_file_llseek users synchronize all on the inode i_mutex,
which is very heavy handed because it affects even different processes.

This patchkit attempts to make generic_file_llseek (mostly) lockless.

For details see the individual patches.

v2: Forward ported to recent kernel. Add SEEK_DATA/HOLE support.
Fix a nasty SEEK_END bug in the previous version.
v3: No changes, except rebase. All reviews passed. Just reposting 
for merging.

-Andi
