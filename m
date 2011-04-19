Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1DSBtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:49:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58914 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1DSBtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:49:01 -0400
Message-ID: <4DACE6E3.8080200@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 09:35:31 +0800
From: liubo <liubo2009@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 2/2] tracing: update btrfs's tracepoints to use u64 interface
References: <4D9573DB.4010009@cn.fujitsu.com>	 <1301665762.2160.22.camel@gandalf.stny.rr.com>	 <4D9C2FF6.7090607@cn.fujitsu.com> <1303150309.7181.51.camel@gandalf.stny.rr.com>
In-Reply-To: <1303150309.7181.51.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-19 09:34:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-19 09:49:32,
	Serialize complete at 2011-04-19 09:49:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To avoid 64->32 truncating WARNING, update btrfs's tracepoints.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
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
1.6.5.2
