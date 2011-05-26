Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab1EZPar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:30:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47819 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab1EZPaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:30:00 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=5SbgR9hLc8YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=kpwzS4f1RtdLK2ulOSoA:9 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110526152958.658980327@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 11:25:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 11/12] tracing: Update btrfss tracepoints to use u64 interface
References: <20110526152541.995963172@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-Update-btrfs-s-tracepoints-to-use-u64-interf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liubo <liubo2009@cn.fujitsu.com>

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
-- 
1.7.4.4


