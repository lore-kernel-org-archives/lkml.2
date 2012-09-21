Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab2IUJbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:31:23 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50149 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685Ab2IUJbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:31:21 -0400
From: Guo Chao <yan@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: dchinner@redhat.com, hch@infradead.org, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v4 Patch 0/4] fs/inode.c: optimization for inode lock usage
Date: Fri, 21 Sep 2012 17:31:02 +0800
Message-Id: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
x-cbid: 12092109-5564-0000-0000-0000048F3D52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset optimizes several places which take the per inode spin lock.
They have not been fully tested yet, thus they are marked as RFC. 

I do limited tests after all patches applied: use two 'find' to traverse the 
filesystems and touch all files in parallel. This runs for several days in a 
virtual machine, no suspicious log appears. 

Guo Chao (4):
  fs/inode.c: do not take i_lock on newly allocated inode
  fs/inode.c: do not take i_lock in __(insert|remove)_inode_hash
  fs/inode.c: do not take i_lock when identify an inode
  fs/inode.c: always take i_lock before calling filesystem's test()
    method

 fs/inode.c |   32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

-- 
1.7.9.5

