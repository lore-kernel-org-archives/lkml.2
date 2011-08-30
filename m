Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1H3BsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:48:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41739 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab1H3BsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:48:07 -0400
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH][Resend][Trivial] tags, powerpc: Update tags.sh to support _GLOBAL symbols
From: Ian Munsie <imunsie@au1.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        trivial <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 30 Aug 2011 11:47:58 +1000
Message-Id: <1314668427-sup-1740@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC we use _GLOBAL throughout the assembly to define symbols, but
currently these symbols are missing from the tags generated with
ARCH=powerpc make tags. This patch modifies the tags.sh script to
recognise _GLOBAL(.*) so that these symbols will be in the tags.

This is almost (but not quite) PowerPC specific and this change should
not affect anyone else:

$ git grep -E '^_GLOBAL\(([^)]*)\).*' |sed 's/^\([^/]*\/[^/]*\)\/.*$/\1/'|uniq -c
    627 arch/powerpc
      2 arch/um

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
I've had no (online) response to this so far - hoping that this can be
picked up by someone.

 scripts/tags.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 75c5d24f1..38f6617 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -129,7 +129,7 @@ exuberant()
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	--extra=+f --c-kinds=+px                                \
-	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
+	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
 	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
 	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'
@@ -151,7 +151,7 @@ exuberant()
 emacs()
 {
 	all_sources | xargs $1 -a                               \
-	--regex='/^ENTRY(\([^)]*\)).*/\1/'                      \
+	--regex='/^(ENTRY|_GLOBAL)(\([^)]*\)).*/\2/'            \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
 	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/'
-- 
1.7.2.5
