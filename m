Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2EQIjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:39:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58601 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab2EQIjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:39:11 -0400
Date: Thu, 17 May 2012 01:37:40 -0700
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
Subject: [PATCH v2 0/6] Merge ram_console into pstore
Message-ID: <20120517083740.GA25627@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In v2:

- Updated documentation per Colin Cross' comments;
- Corrected return value in ramoops_pstore_write() (noticed by Kees Cook);
- Fixed large writes handling in pstore_console_write(), i.e. when
  log_buf write is larger than pstore bufsize. Also Noticed by Kees Cook.

These patches depend on the the following series:
http://thread.gmane.org/gmane.linux.kernel/1298642
"[PATCH v3 0/3] Merge ramoops and persistent_ram, generic pstore RAM backend"

And a rationale for the series:

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

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
