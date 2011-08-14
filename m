Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1HNQOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:14:46 -0400
Received: from mail.globalsuite.net ([69.46.103.200]:64127 "EHLO
	mail.globalsuite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab1HNQOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:14:41 -0400
X-Greylist: delayed 3598 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Aug 2011 12:14:40 EDT
X-AuditID: c0a8013c-b7b24ae000000ba8-b2-4e47eb0afa79
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
Subject: [PATCH v3 0/4] Per-container dcache limitation
Date: Sun, 14 Aug 2011 19:13:48 +0400
Message-Id: <1313334832-1150-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series is just like v2, except it addresses
Eric's comments regarding percpu variables.

Let me know if there are further comments, and
I'll promply address them as well. Otherwise,
I feel this is ready for inclusion

Glauber Costa (4):
  factor out single-shrinker code
  Keep nr_dentry per super block
  limit nr_dentries per superblock
  parse options in the vfs level

 fs/dcache.c              |   47 ++++++++++++-
 fs/namespace.c           |  105 ++++++++++++++++++++++++++
 fs/super.c               |    5 +
 include/linux/dcache.h   |    4 +
 include/linux/fs.h       |    3 +
 include/linux/shrinker.h |    6 ++
 mm/vmscan.c              |  185 ++++++++++++++++++++++++----------------------
 7 files changed, 267 insertions(+), 88 deletions(-)

-- 
1.7.6

