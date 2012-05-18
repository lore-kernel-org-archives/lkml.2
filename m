Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967750Ab2ERWYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:24:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58883 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2ERWYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:24:45 -0400
Date: Fri, 18 May 2012 15:23:14 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH v3 0/14] Merge ram_console into pstore, and more
Message-ID: <20120518222314.GA9425@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here comes v3:

- Rebased on top of current staging-next;
- The series are getting bigger. This is partly because we now support
  different persistent zone sizes for oops records and console log,
  per Colin Cross' request.
  And I believe the code is now more manageable for further enhancements
  (e.g. if we'd want to add other message types, e.g. tracing);
- Addressed Kees Cook's comments on the unlinking matters;
- Removed automatic updates support. Please see the last patch
  description for rationale;
- A new fixup for pstore/inode, just getting rid of a sparse warning.

In v2:

- Updated documentation per Colin Cross' comments;
- Corrected return value in ramoops_pstore_write() (noticed by Kees Cook);
- Fixed large writes handling in pstore_console_write(), i.e. when
  log_buf write is larger than pstore bufsize. Also Noticed by Kees Cook.


And a boilerplate for the series:

Currently pstore doesn't support logging kernel messages in run-time,
it only dumps dmesg when kernel oopses/panics. This makes pstore
useless for debugging hangs caused by HW issues or improper use of HW
(e.g. weird device inserted -> driver tried to write reserved bits ->
SoC hanged. In that case we don't get any messages in the pstore.

This series add a new message type for pstore, i.e. PSTORE_TYPE_CONSOLE,
plus make pstore/ram.c handle the new messages.

The old ram_console driver is removed. This might probably cause
some pain for out-of-tree code, as it would need to be adjusted...
but "no pain, no gain"? :-) Though, if there's some serious resistance,
we can probably postpone the last two patches.

Thanks!

--- 
 Documentation/ramoops.txt             |   14 ++
 drivers/staging/android/Kconfig       |    5 -
 drivers/staging/android/Makefile      |    1 -
 drivers/staging/android/ram_console.c |  179 --------------------------
 fs/pstore/Kconfig                     |    7 +
 fs/pstore/inode.c                     |    5 +-
 fs/pstore/platform.c                  |   70 +++++-----
 fs/pstore/ram.c                       |  228 ++++++++++++++++++++++++++-------
 fs/pstore/ram_core.c                  |  109 ++++------------
 include/linux/pstore.h                |    1 +
 include/linux/pstore_ram.h            |   22 +---
 11 files changed, 269 insertions(+), 372 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
