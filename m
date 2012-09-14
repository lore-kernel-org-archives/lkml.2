Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2INF4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:56:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2INF4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:56:47 -0400
Date: Thu, 13 Sep 2012 22:56:28 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@gmail.com>
Message-ID: <tip-3f34f6c0233ae055b592e8f8da23d873b82070bb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        rostedt@goodmis.org, irina.tirdea@intel.com, irina.tirdea@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, rostedt@goodmis.org,
        irina.tirdea@intel.com, dsahern@gmail.com, irina.tirdea@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1347315303-29906-4-git-send-email-irina.tirdea@intel.com>
References: <1347315303-29906-4-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: include __WORDSIZE definition
Git-Commit-ID: 3f34f6c0233ae055b592e8f8da23d873b82070bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 22:56:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f34f6c0233ae055b592e8f8da23d873b82070bb
Gitweb:     http://git.kernel.org/tip/3f34f6c0233ae055b592e8f8da23d873b82070bb
Author:     Irina Tirdea <irina.tirdea@gmail.com>
AuthorDate: Tue, 11 Sep 2012 01:15:00 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Sep 2012 11:47:45 -0300

perf tools: include __WORDSIZE definition

__WORDSIZE is GLibC-specific and is not defined on all systems or glibc
versions (e.g. Android's bionic does not define it).

In file included from util/include/linux/bitmap.h:5:0,
                 from util/header.h:10,
                 from util/session.h:6,
                 from util/build-id.h:4,
                 from util/annotate.c:11:
util/include/linux/bitops.h: In function 'set_bit':
util/include/linux/bitops.h:25:12: error:
'__WORDSIZE' undeclared (first use in this function)
util/include/linux/bitops.h:25:12: note:
each undeclared identifier is reported only once for each function it appears in
util/include/linux/bitops.h:23:51: error:
parameter 'addr' set but not used [-Werror=unused-but-set-parameter]
util/include/linux/bitops.h: In function 'clear_bit':
util/include/linux/bitops.h:30:12: error:
'__WORDSIZE' undeclared (first use in this function)
util/include/linux/bitops.h:28:53: error:
parameter 'addr' set but not used [-Werror=unused-but-set-parameter]
In file included from util/header.h:10:0,
                 from util/session.h:6,
                 from util/build-id.h:4,
                 from util/annotate.c:11:
util/include/linux/bitmap.h: In function 'bitmap_zero':
util/include/linux/bitmap.h:22:6: error:
'__WORDSIZE' undeclared (first use in this function)

Defining __WORDSIZE in perf's headers if it is not already defined.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Suggested-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Irina Tirdea <irina.tirdea@intel.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347315303-29906-4-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/bitops.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/linux/bitops.h b/tools/perf/util/include/linux/bitops.h
index 587a230..a55d8cf 100644
--- a/tools/perf/util/include/linux/bitops.h
+++ b/tools/perf/util/include/linux/bitops.h
@@ -5,6 +5,10 @@
 #include <linux/compiler.h>
 #include <asm/hweight.h>
 
+#ifndef __WORDSIZE
+#define __WORDSIZE (__SIZEOF_LONG__ * 8)
+#endif
+
 #define BITS_PER_LONG __WORDSIZE
 #define BITS_PER_BYTE           8
 #define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
