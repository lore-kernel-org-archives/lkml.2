Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab2GZO1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:27:24 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34539 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2GZO1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:27:23 -0400
Date: Thu, 26 Jul 2012 07:25:14 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 0/7] KDB: Kiosk (reduced capabilities) mode
Message-ID: <20120726142514.GA32158@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a patchset that implements "kiosk" mode for KDB debugger. The
mode provides reduced set of features, so that it is no longer possible
to leak sensitive data via the debugger, and not possible to change
program flow in a predefined manner.

The are two use-cases for the mode, one is evil, but another is quite
legitimate.

The evil use case is used by some (ahem) phone manufaturers that want
to have a debuging facilities on a production device, but still don't
want you to use the debugger to gain root access. I don't like locked
phones, and I would not touch this/get my hands dirty by implementing
the feature just for this evil (IMHO) use case.

But there is another non-evil use case: limitting access to public
devices, i.e. "kiosks", ATMs (is that too much?) or just public
computers w/ guest access. I can imagine that an administrator would
want to setup a kernel so that upon an oops (or a sysrq event) the
kernel would enter KDB, but at the same time, he would not want to
leak sensitive data from the PC by means of the debugger.

There are seven patches, the first five of them are just cleanups and
preparations. I believe these five patches are good even if not
considering the kiosk mode. And the rest of patches actually implement
the mode -- it is pretty straightforward.

Note that we might impelement the same mode for KGDB stub, but so far
we don't bother.

Thanks!

--
 include/linux/kdb.h            |   16 ++--
 kernel/debug/kdb/kdb_bp.c      |   35 ++++----
 kernel/debug/kdb/kdb_main.c    |  183 +++++++++++++++++++++-------------------
 kernel/debug/kdb/kdb_private.h |    3 +-
 kernel/trace/trace_kdb.c       |    4 +-
 5 files changed, 126 insertions(+), 115 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
