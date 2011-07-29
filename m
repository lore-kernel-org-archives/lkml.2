Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1G2NpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:45:13 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:48540 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1G2NpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:45:08 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        David Chinner <david@fromorbit.com>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 0/4] Per-superblock dcache limitation
Date: Fri, 29 Jul 2011 17:44:15 +0400
Message-Id: <1311947059-17209-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Now that we've got per-sb dcache lru lists, I am proposing
through theses patches that each of those be size-limited.
The main use case I am targetting is containers, where we want
a container not to use more than a certain specified amount
of non-shrikable kernel memory. 

Comments welcome

Glauber Costa (4):
  Keep nr_dentry per super block
  limit nr_dentries per superblock
  dcache set size
  parse options in the vfs level

 fs/dcache.c            |   75 +++++++++++++++++++++++++++++++---------
 fs/namespace.c         |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/super.c             |    3 ++
 include/linux/dcache.h |    1 +
 include/linux/fs.h     |    3 ++
 5 files changed, 155 insertions(+), 16 deletions(-)

-- 
1.7.6

