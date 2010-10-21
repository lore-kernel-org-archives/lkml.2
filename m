Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0JUHlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:41:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:40698 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab0JUHk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:40:59 -0400
Date: Thu, 21 Oct 2010 07:40:39 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, shaohua.li@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, tglx@linutronix.de, shaohua.li@intel.com
In-Reply-To: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-32, percpu: Correct the ordering of the percpu readmostly section
Message-ID: <tip-2aeb66d3036dbafc297ac553a257a40283dadb3e@git.kernel.org>
Git-Commit-ID: 2aeb66d3036dbafc297ac553a257a40283dadb3e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Oct 2010 07:40:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2aeb66d3036dbafc297ac553a257a40283dadb3e
Gitweb:     http://git.kernel.org/tip/2aeb66d3036dbafc297ac553a257a40283dadb3e
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 21 Oct 2010 00:15:00 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 21 Oct 2010 00:15:00 -0700

x86-32, percpu: Correct the ordering of the percpu readmostly section

Checkin c957ef2c59e952803766ddc22e89981ab534606f had inconsistent
ordering of .data..percpu..page_aligned and .data..percpu..readmostly;
the still-broken version affected x86-32 at least.

The page aligned version really must be page aligned...

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/asm-generic/vmlinux.lds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index d7e7b21..1457b81 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -706,8 +706,8 @@
 		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
 		*(.data..percpu..first)					\
 		. = ALIGN(PAGE_SIZE);					\
-		*(.data..percpu..readmostly)				\
 		*(.data..percpu..page_aligned)				\
+		*(.data..percpu..readmostly)				\
 		*(.data..percpu)					\
 		*(.data..percpu..shared_aligned)			\
 		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
