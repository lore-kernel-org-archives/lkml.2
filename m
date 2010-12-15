Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0LOJe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:34:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62901 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0LOJe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:34:56 -0500
Message-ID: <4D088BC5.5060707@cn.fujitsu.com>
Date: Wed, 15 Dec 2010 17:35:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: [PATCH v2 1/6] cgroups: Shrink struct cgroup_subsys
References: <4D088BB5.30903@cn.fujitsu.com>
In-Reply-To: <4D088BB5.30903@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:34:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:34:54,
	Serialize complete at 2010-12-15 17:34:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_32, sizeof(struct cgroup_subsys) shrinks from 276 bytes
to 264.

Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ed4ba11..63d953d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -481,14 +481,16 @@ struct cgroup_subsys {
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
 
 	int subsys_id;
-	int active;
-	int disabled;
-	int early_init;
+
+	bool active:1;
+	bool disabled:1;
+	bool early_init:1;
 	/*
 	 * True if this subsys uses ID. ID is not available before cgroup_init()
 	 * (not available in early_init time.)
 	 */
-	bool use_id;
+	bool use_id:1;
+
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
 
-- 
1.6.3
