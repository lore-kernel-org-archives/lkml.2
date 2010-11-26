Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0KZDDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 22:03:51 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58443 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0KZDDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 22:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QDFtyoqyJwQplEVYNcCU4ymRnE7BcqHOZ0aidgisuFlzSUovjs5y5ZoYrMoxNUIAy8
         Ddb7/0h1Lv1PO3p8AlP84jAO8WjP0o/47i/RUqkVEZgynsk1NkiZyNkf4HczYJhdHZfE
         Yl2/7YVidCFQAiyWHbPSUfmXpCe0rl0aHUrl8=
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        will.deacon@arm.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH v2 0/5] MIPS/Perf-events: Sync with mainline upper layer (v2)
Date: Fri, 26 Nov 2010 11:05:02 +0800
Message-Id: <1290740707-32586-1-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current MIPS Perf-events uses older interfaces to the generic layer. So it
will not work. This patch set fixes this issue (reported by Wu Zhangjin) by
adding MIPS counterparts for a list of previous commits that went to
mainline earlier.

Changes:
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

