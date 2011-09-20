Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab1ITThL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:37:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:38849 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1ITThJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:37:09 -0400
Subject: Re: [PATCH 3/8] kstaled: page_referenced_kstaled() and supporting
 infrastructure.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>,
        rostedt <rostedt@goodmis.org>
Date: Tue, 20 Sep 2011 21:36:39 +0200
In-Reply-To: <1316230753-8693-4-git-send-email-walken@google.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	 <1316230753-8693-4-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316547399.13664.65.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 20:39 -0700, Michel Lespinasse wrote:
> +PAGEFLAG(Young, young)

We should probably do something like the below, I couldn't figure out a
way to make it do multiple functions from one macro though so I picked
the simple PageFoo test.. 

I even added an Emacs variant, although I didn't test it..

---
 scripts/tags.sh |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 75c5d24f1..b07797a 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -132,7 +132,8 @@ exuberant()
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
 	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
-	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'
+	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'	\
+	--regex-c++='/^PAGEFLAG\(([^,)]*).*/Page\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -154,7 +155,8 @@ emacs()
 	--regex='/^ENTRY(\([^)]*\)).*/\1/'                      \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
-	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/'
+	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/'\
+	--regex='/^PAGEFLAG(\([^,)]*\).*/Page\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'

