Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2HOTv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:28 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62987 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab2HOTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 097/165] xen/timer: Missing IRQF_NO_SUSPEND in timer code broke suspend.
Date: Wed, 15 Aug 2012 15:47:21 -0400
Message-ID: <1345060109-9187-98-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit f611f2da99420abc973c32cdbddbf5c365d0a20c upstream.

The patches missed an indirect use of IRQF_NO_SUSPEND pulled in via
IRQF_TIMER. The following patch fixes the issue.

With this fixlet PV guest migration works just fine. I also booted the
entire series as a dom0 kernel and it appeared fine.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/xen/time.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index a05bda6..fb2b388 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -396,7 +396,9 @@ void xen_setup_timer(int cpu)
 		name = "<timer kasprintf failed>";
 
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
-				      IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING|IRQF_TIMER,
+				      IRQF_DISABLED|IRQF_PERCPU|
+				      IRQF_NOBALANCING|IRQF_TIMER|
+				      IRQF_FORCE_RESUME,
 				      name, NULL);
 
 	evt = &per_cpu(xen_clock_events, cpu);
-- 
1.7.12.rc2

