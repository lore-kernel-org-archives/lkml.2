Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab2JEDMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 23:12:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45241 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab2JEDMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 23:12:07 -0400
Date: Thu, 4 Oct 2012 20:09:21 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>
Subject: [GIT PULL] linux-pstore.git
Message-ID: <20121005030920.GB8754@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please also pull a few pstore updates,

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.infradead.org/users/cbou/linux-pstore.git tags/for-v3.7

for you to fetch changes up to 80c9d03c22f13a17df67b4b99a83ed5e9acf6093:

  pstore: Avoid recursive spinlocks in the oops_in_progress case (2012-09-20 17:04:50 -0700)

----------------------------------------------------------------
1. We no longer ad-hoc to the function tracer "high level" infrastructure
   and no longer use its debugfs knobs. The change slightly touches
   kernel/trace directory, but it got the needed ack from Steven Rostedt:
   http://lkml.org/lkml/2012/8/21/688
2. Added maintainers entry;
3. A bunch of fixes, nothing special.

----------------------------------------------------------------
Anton Vorontsov (4):
      pstore/ram: Fix possible NULL dereference
      pstore/ram: Mark ramoops_pstore_write_buf() as notrace
      MAINTAINERS: Add pstore maintainers
      pstore/ftrace: Convert to its own enable/disable debugfs knob

Chuansheng Liu (1):
      pstore: Avoid recursive spinlocks in the oops_in_progress case

Jovi Zhang (1):
      pstore/ram: Add missing platform_device_unregister

Randy Dunlap (1):
      pstore/ram: Fix printk format warning

 Documentation/ramoops.txt      |  4 +-
 MAINTAINERS                    | 12 +++++
 fs/pstore/Kconfig              |  1 +
 fs/pstore/ftrace.c             | 96 +++++++++++++++++++++++++++++++++++-
 fs/pstore/internal.h           |  6 +++
 fs/pstore/platform.c           |  9 +++-
 fs/pstore/ram.c                | 28 ++++++-----
 include/linux/pstore.h         |  8 ---
 kernel/trace/trace_functions.c | 15 +-----
 9 files changed, 139 insertions(+), 40 deletions(-)
