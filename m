Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2CIJCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:02:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab2CIJCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:02:37 -0500
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] Get rid of iput() from flusher thread
Date: Fri,  9 Mar 2012 10:02:24 +0100
Message-Id: <1331283748-12959-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  this patch set changes writeback_sb_inodes() to avoid iput() which might
be problematic (see patch 4 which tries to summarize our email discussions)
for some filesystems.

  Patches 1 and 2 are trivial mostly unrelated fixes (Fengguang, can you can
take these and merge them right away please?). Patch 3 is a preparatory code
reshuffle and patch 4 removes the __iget() / iput() from flusher thread.

  As a side note, your patches to offload writeback from kswapd to flusher
thread then won't need iget/iput either if we pass page references as we talked
so that should resolve most of the concerns.

  What do you think guys?

								Honza
