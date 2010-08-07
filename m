Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0HGPcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 11:32:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:46916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab0HGPcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 11:32:35 -0400
Message-ID: <4C5D7C4C.1020206@kernel.org>
Date: Sat, 07 Aug 2010 17:31:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] cgroup: add missing __percpu markup in mm/memcontrol.c
References: <1281194812-18052-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281194812-18052-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 Aug 2010 15:31:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

mem_cgroup->stat is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
Namhyung, can you please look up the maintainers in MAINTAINERS and/or
using scripts/get_maintainer.pl and submit __percpu markup patches to
the respective maintainers w/ me cc'd?

Thank you.

 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 20a8193..edf5011 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -252,7 +252,7 @@ struct mem_cgroup {
 	/*
 	 * percpu counter.
 	 */
-	struct mem_cgroup_stat_cpu *stat;
+	struct mem_cgroup_stat_cpu __percpu *stat;
 };

 /* Stuffs for move charges at task migration. */
-- 
1.7.0.4
