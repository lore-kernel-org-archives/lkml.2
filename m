Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab0K2JRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:17:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59002 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab0K2JRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IhQYTsBxXqDM8ENfTaknHaqDFOF6zCqJxAVqQQDbrlR5rYstRJCG2faHhPTlqZZa1j
         k+RuA0bJHcIT77vlvoScBLKa260bLs26w9mwNnvBLNSLoOSuS7+iWf2QfJLgodsc3ZYN
         lHoWSoQz3ahSZAJcw5VCbeYI+dMUscdsskP6Y=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com, matt@console-pimps.org, sshtylyov@mvista.com
Subject: [PATCH v3 0/5] MIPS/Perf-events: Sync with mainline upper layer (v3)
Date: Mon, 29 Nov 2010 17:19:06 +0800
Message-Id: <1291022351-13152-1-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current MIPS Perf-events uses older interfaces to the generic layer. So it
will not work. This patch set fixes this issue (reported by Wu Zhangjin) by
adding MIPS counterparts for a list of previous commits that went to
mainline earlier.

Changes:
v3 - v2:
o Keep all mentioned commits in the form of number + title + original
summary + (MIPS specific info when needed).
v2 - v1:
o Corrected the return value of the event check in validate_event().

Deng-Cheng Zhu (5):
  MIPS/Perf-events: Work with irq_work
  MIPS/Perf-events: Work with the new PMU interface
  MIPS/Perf-events: Fix event check in validate_event()
  MIPS/Perf-events: Work with the new callchain interface
  MIPS/Perf-events: Use unsigned delta for right shift in event update

 arch/mips/Kconfig                    |    1 +
 arch/mips/include/asm/perf_event.h   |   12 +-
 arch/mips/kernel/perf_event.c        |  345 ++++++++++++++++------------------
 arch/mips/kernel/perf_event_mipsxx.c |    4 +-
 4 files changed, 171 insertions(+), 191 deletions(-)

