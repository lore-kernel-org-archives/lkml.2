Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1AUITp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:19:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52164 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1AUITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:19:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mqNJ8bqsns/XC9ktgozVw6ysiAsKS3mC76wmdI96fMYxT+7eR58dYrn15DxTIV+mj3
         qoBT2RCdKqAU+J8Dw5vx2TflyzRDHNChuZjSUYmrpOmHjV9L1h4QJUHJecE+iIMpuLhC
         k6ifQhUcf6181ELJ3kAeU4+vqXL+mUKDBWYGk=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com, matt@console-pimps.org, sshtylyov@mvista.com,
        ddaney@caviumnetworks.com
Subject: [PATCH v4 0/5] MIPS/Perf-events: Sync with mainline upper layer (v4)
Date: Fri, 21 Jan 2011 16:19:16 +0800
Message-Id: <1295597961-7565-1-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current MIPS Perf-events uses older interfaces to the generic layer. So it
will not work. This patch set fixes this issue (reported by Wu Zhangjin) by
adding MIPS counterparts for a list of previous commits that went to
mainline earlier.

Changes:
v4 - v3:
o Rebase this patch set to have early_initcall instead of arch_initcall for
init_hw_perf_events.
o Change the arguments of perf_pmu_register() in Patch #2.
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

