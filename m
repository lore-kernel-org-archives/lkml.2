Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab2DTTfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:35:53 -0400
Received: from outmail020.snc4.facebook.com ([66.220.144.154]:59765 "EHLO
	intmgw003.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751119Ab2DTTfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:35:52 -0400
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH 0/3] perf: Support multiple stacks (v2)
Date: Fri, 20 Apr 2012 12:35:24 -0700
Message-Id: <1334950527-5050-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If userspace has two or more stacks and we happen to take a sample when
the stack pointer is pointing to a higher stack, we might get truncated
callchains. This patch series tries to address that.

Changelog:

v2: do this for compat32 as well
v2: improve safety checks and reduce max callchain size

Arun Sharma (3):
  perf, x86: Allow multiple stacks
  perf, x86: Don't leak kernel data via callchains
  perf, x86: Limit callchains to 127

 arch/x86/kernel/cpu/perf_event.c |   14 +++++++-------
 include/linux/perf_event.h       |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.7.8.4

