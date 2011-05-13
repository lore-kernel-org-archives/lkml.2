Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab1EMIv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:51:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13077 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758443Ab1EMIvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:51:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=IlXPUzrSLiEXC/Obrp8tFRPu/NQEKVIxgRua6cPYpEdsi4yMnfzV6Kns3TpVZshc8
	CCmPDUhkzJcMJr893i+2Q==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>
Subject: [RFC][PATCH v7 08/14] writeback: add memcg fields to writeback_control
Date: Fri, 13 May 2011 01:47:47 -0700
Message-Id: <1305276473-14780-9-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305276473-14780-1-git-send-email-gthelen@google.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add writeback_control fields to differentiate between bdi-wide and
per-cgroup writeback.  Cgroup writeback is also able to differentiate
between writing inodes isolated to a particular cgroup and inodes shared
by multiple cgroups.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 include/linux/writeback.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index d10d133..4f5c0d2 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -47,6 +47,8 @@ struct writeback_control {
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+	unsigned for_cgroup:1;		/* enable cgroup writeback */
+	unsigned shared_inodes:1;	/* write inodes spanning cgroups */
 };
 
 /*
-- 
1.7.3.1

