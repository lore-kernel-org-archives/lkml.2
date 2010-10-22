Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0JVIIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:08:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab0JVIIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:08:36 -0400
Message-ID: <4CC146BA.7080009@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 16:09:30 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "akpm >> Andrew Morton" <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: [PATCH 1/7] cgroups: Shrink struct cgroup_subsys
References: <4CC146A4.9090505@cn.fujitsu.com>
In-Reply-To: <4CC146A4.9090505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_32, sizeof(struct cgroup_subsys) shrinks from 276 bytes
to 264.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
include/linux/cgroup.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index ed4ba11..e23ded6 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -481,14 +481,16 @@ struct cgroup_subsys {
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
 
 	int subsys_id;
-	int active;
-	int disabled;
-	int early_init;
+
+	unsigned int active:1;
+	unsigned int disabled:1;
+	unsigned int early_init:1;
 	/*
 	 * True if this subsys uses ID. ID is not available before cgroup_init()
 	 * (not available in early_init time.)
 	 */
-	bool use_id;
+	unsigned int use_id:1;
+
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
 
-- 
1.7.0.1

