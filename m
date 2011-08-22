Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1HVUtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:49:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:49528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab1HVUtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:49:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,265,1312182000"; 
   d="scan'208";a="43951953"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Improve lseek scalability
Date: Mon, 22 Aug 2011 13:49:05 -0700
Message-Id: <1314046152-2175-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently generic_file_llseek users synchronize all on the inode i_mutex,
which is very heavy handed because it affects even different processes.

This patchkit attempts to make generic_file_llseek (mostly) lockless.

For details see the individual patches.

This is a repost of the earlier version which got some reviews.

v2: Forward ported to recent kernel. Add SEEK_DATA/HOLE support.
Fix a nasty SEEK_END bug in the previous version.

-Andi

