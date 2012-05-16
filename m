Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab2EPMzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:55:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47261 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760021Ab2EPMzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:55:01 -0400
Date: Wed, 16 May 2012 05:53:30 -0700
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
Subject: [PATCH 0/6] Merge ram_console into pstore
Message-ID: <20120516125330.GA15460@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

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

These patches depend on the following series:
http://thread.gmane.org/gmane.linux.kernel/1298179
"[PATCH v2 0/6] Merge ramoops and persistent_ram, generic pstore RAM backend"

Thanks!

--- 
 Documentation/ramoops.txt             |   15 +++
 drivers/staging/android/Kconfig       |    5 -
 drivers/staging/android/Makefile      |    1 -
 drivers/staging/android/ram_console.c |  179 ---------------------------------
 fs/pstore/Kconfig                     |    7 ++
 fs/pstore/inode.c                     |    3 +
 fs/pstore/platform.c                  |   25 +++++
 fs/pstore/ram.c                       |   39 +++++--
 fs/pstore/ram_core.c                  |   81 +--------------
 include/linux/pstore.h                |    1 +
 include/linux/pstore_ram.h            |   19 ----
 11 files changed, 83 insertions(+), 292 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
