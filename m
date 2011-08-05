Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab1HEAgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 20:36:31 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:28690 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab1HEAg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 20:36:26 -0400
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
Subject: [PATCH v2 0/4] Per-container dcache size limitation
Date: Fri,  5 Aug 2011 04:35:40 +0400
Message-Id: <1312504544-1108-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since v1, there is not too much new here.
I'm incorporating David's suggestion of calling the sb
shrinker, which will, in effect, prune the icache and
other sb related objects as well.

I am also keeping the mount based interface, since I
still believe it is the way to go. But I'm obviously
still open for suggestions. Some small corrections
were also made to it since v1. Specifically, bind
mounts are not allowed to alter the original sb dcache
size.

Glauber Costa (4):
  factor out single-shrinker code
  Keep nr_dentry per super block
  limit nr_dentries per superblock
  parse options in the vfs level

 fs/dcache.c              |   44 +++++++++++-
 fs/namespace.c           |  105 ++++++++++++++++++++++++++
 fs/super.c               |   16 ++++-
 include/linux/dcache.h   |    4 +
 include/linux/fs.h       |    3 +
 include/linux/shrinker.h |    6 ++
 mm/vmscan.c              |  185 ++++++++++++++++++++++++----------------------
 7 files changed, 274 insertions(+), 89 deletions(-)

-- 
1.7.6

