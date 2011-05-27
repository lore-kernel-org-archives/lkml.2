Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1E0Msl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:48:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:52029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab1E0Msi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:48:38 -0400
Date: Fri, 27 May 2011 12:48:30 GMT
From: tip-bot for liubo <liubo2009@cn.fujitsu.com>
Message-ID: <tip-7f34b746f79c1e1f8fd6d09799d133263ae7a504@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        liubo2009@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        liubo2009@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4DACE6E3.8080200@cn.fujitsu.com>
References: <4DACE6E3.8080200@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Update btrfs's tracepoints to use u64 interface
Git-Commit-ID: 7f34b746f79c1e1f8fd6d09799d133263ae7a504
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 May 2011 12:48:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f34b746f79c1e1f8fd6d09799d133263ae7a504
Gitweb:     http://git.kernel.org/tip/7f34b746f79c1e1f8fd6d09799d133263ae7a504
Author:     liubo <liubo2009@cn.fujitsu.com>
AuthorDate: Tue, 19 Apr 2011 09:35:31 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 25 May 2011 22:13:47 -0400

tracing: Update btrfs's tracepoints to use u64 interface

To avoid 64->32 truncating WARNING, update btrfs's tracepoints.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/4DACE6E3.8080200@cn.fujitsu.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/btrfs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index f445cff..4114129 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -28,7 +28,7 @@ struct extent_buffer;
 		{ BTRFS_SHARED_DATA_REF_KEY, 	"SHARED_DATA_REF" })
 
 #define __show_root_type(obj)						\
-	__print_symbolic(obj,						\
+	__print_symbolic_u64(obj,					\
 		{ BTRFS_ROOT_TREE_OBJECTID, 	"ROOT_TREE"	},	\
 		{ BTRFS_EXTENT_TREE_OBJECTID, 	"EXTENT_TREE"	},	\
 		{ BTRFS_CHUNK_TREE_OBJECTID, 	"CHUNK_TREE"	},	\
@@ -125,7 +125,7 @@ DEFINE_EVENT(btrfs__inode, btrfs_inode_evict,
 );
 
 #define __show_map_type(type)						\
-	__print_symbolic(type,						\
+	__print_symbolic_u64(type,					\
 		{ EXTENT_MAP_LAST_BYTE, "LAST_BYTE" 	},		\
 		{ EXTENT_MAP_HOLE, 	"HOLE" 		},		\
 		{ EXTENT_MAP_INLINE, 	"INLINE" 	},		\
