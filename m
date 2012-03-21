Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2CUDdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 23:33:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53903 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab2CUDdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 23:33:44 -0400
Date: Wed, 21 Mar 2012 03:33:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [git pull] munmap/truncate race fixes
Message-ID: <20120321033343.GN6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fixes for racy use of unmap_vmas() on truncate-related codepaths.
Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git vm

Shortlog:
Al Viro (6):
      VM: unmap_page_range() can return void
      VM: can't go through the inner loop in unmap_vmas() more than once...
      VM: make zap_page_range() return void
      VM: don't bother with feeding upper limit to tlb_finish_mmu() in exit_mmap()
      VM: make unmap_vmas() return void
      VM: make zap_page_range() callers that act on a single VMA use separate helper

Diffstat:
 include/linux/mm.h |    4 +-
 mm/memory.c        |  133 +++++++++++++++++++++++++++++++---------------------
 mm/mmap.c          |    5 +-
 3 files changed, 84 insertions(+), 58 deletions(-)
