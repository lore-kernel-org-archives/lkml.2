Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2GEDJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:09:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50672 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2GEDJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:09:12 -0400
X-AuditID: 9c93016f-b7c7eae0000025c5-c3-4ff505558392
From: Namhyung Kim <namhyung@kernel.org>
Newsgroups: gmane.linux.kernel
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [Question] sched: Is nsecs_to_cputime valid?
Date: Thu, 05 Jul 2012 12:05:01 +0900
Message-ID: <87txxmlxgi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
Cancel-Lock: sha1:Gd8w0aFr/v1nYr3dPPt+4OVP+S4=
MIME-Version: 1.0
Content-Type: text/plain
Posted-To: gmane.linux.kernel
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following message is a courtesy copy of an article
that has been posted to gmane.linux.kernel as well.

Hi,

When I look at kernel/sched/core.c, I found a dubious bit on the 
nsecs_to_cputime macro. It's defined as:

#ifndef nsecs_to_cputime
# define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
#endif

While default implementation of jiffies_to_cputime (in
include/asm-generic/cputime.h) returns just the same vaule (w/
casting), some arch's (ia64, ppc and s390) define their own ones.
So nsecs_to_cputime on those arch's will end up returning time in
jiffies rather than cputime.

I see it depends on CONFIG_VIRT_CPU_ACCOUTING and ia64 and ppc use
the default j_to_ct when not defined. But it seems it's not obvious for
s390. Anyway I think converting the return value to cputime again is
need for self-containedness.

Am I missing something?

Thanks,
Namhyung
