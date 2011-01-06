Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab1AFOwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:52:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48226 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1AFOwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:52:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=b/JL1x4mTDxmqoWbAmt/F8vM1PgndZkTlJ7d8OwegOPYjentI+7jOGyvLF4z4I8KG8
         bfpvPO8vkqt11j+GJK/UX0IXJdqsRwouHCuc0fgnFd4GCOTjIb7MEjBC0iYtxWIdEzAm
         iR8DSxIEANG3EERA7yyZ+eBoCtyLZdku7H3dk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Soeren Sandmann Pedersen <sandmann@redhat.com>
Subject: [RFC GIT PULL] perf updates
Date: Thu,  6 Jan 2011 15:51:51 +0100
Message-Id: <1294325513-14276-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core
	
Soeren reported some time ago that callchains were broken on
x86_64 with cpu-clock/task-clock events. After some time I
finally found the problem was in the irq low level arg saving.
It touches fragile code though, I hope some people can
have a look over the fix.

Thanks,
	Frederic
---

Frederic Weisbecker (2):
      x86: Fix rbp saving in pt_regs on irq entry
      perf: Build tools with frame pointer


 arch/x86/kernel/entry_64.S |   31 +++++++++++++++++++------------
 tools/perf/Makefile        |    2 +-
 2 files changed, 20 insertions(+), 13 deletions(-)
