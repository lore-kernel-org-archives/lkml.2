Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1GOWlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 18:41:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1GOWlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 18:41:05 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@chromium.org>, Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Olaf Hering <olaf@aepfle.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] panic: panic=-1 for immediate reboot
Date: Fri, 15 Jul 2011 15:39:59 -0700
Message-Id: <1310769600-9234-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@chromium.org>

When kernel BUG or oops occurs, ChromeOS intends to panic and immediately
reboot, with stacktrace and other messages preserved in RAM across reboot.
But the longer we delay, the more likely the user is to poweroff and lose
the info.

panic_timeout (seconds before rebooting) is set by panic= boot option
or sysctl or /proc/sys/kernel/panic; but 0 means wait forever, so at
present we have to delay at least 1 second.

Let a negative number mean reboot immediately (with the small cosmetic
benefit of suppressing that newline-less "Rebooting in %d seconds.."
message).

Signed-off-by: Hugh Dickins <hughd@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 kernel/panic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 6923167..d7bb697 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -119,6 +119,8 @@ NORET_TYPE void panic(const char * fmt, ...)
 			}
 			mdelay(PANIC_TIMER_STEP);
 		}
+	}
+	if (panic_timeout != 0) {
 		/*
 		 * This will not be a clean reboot, with everything
 		 * shutting down.  But if there is a chance of
-- 
1.7.3.1

