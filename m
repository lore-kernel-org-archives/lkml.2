Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2DTWwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:52:54 -0400
Received: from intmgw002.ash2.facebook.com ([66.220.155.179]:61055 "EHLO
	intmgw001.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756201Ab2DTWwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:52:53 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH 0/4] perf: Support multiple stacks (v3)
Date: Fri, 20 Apr 2012 15:41:32 -0700
Message-Id: <1334961696-19580-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If userspace has two or more stacks and we happen to take a sample when
the stack pointer is pointing to a higher stack, we get truncated
callchains. This patch series tries to address that.

Changelog:

v3: add explicit checks to copy_from_user_nmi
v3: add explicit checks in perf_callchain_user*

v2: do this for compat32 as well
v2: improve safety checks and reduce max callchain size


Arun Sharma (4):
  perf, x86: Allow multiple stacks
  perf: Limit callchains to 127
  perf, x86: Check if user fp is valid
  x86: Check user address explicitly in copy_from_user_nmi()

 arch/x86/include/asm/uaccess.h   |   13 +++++++------
 arch/x86/kernel/cpu/perf_event.c |   11 +++++++++--
 arch/x86/lib/usercopy.c          |    3 +++
 include/linux/perf_event.h       |    2 +-
 4 files changed, 20 insertions(+), 9 deletions(-)

-- 
1.7.8.4

