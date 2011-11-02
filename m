Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668Ab1KCBhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:37:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355Ab1KCBg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.463523097@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [091/107] xen/timer: Missing IRQF_NO_SUSPEND in timer code broke suspend.
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <Ian.Campbell@citrix.com>

commit f611f2da99420abc973c32cdbddbf5c365d0a20c upstream.

The patches missed an indirect use of IRQF_NO_SUSPEND pulled in via
IRQF_TIMER. The following patch fixes the issue.

With this fixlet PV guest migration works just fine. I also booted the
entire series as a dom0 kernel and it appeared fine.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/time.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -395,7 +395,9 @@ void xen_setup_timer(int cpu)
 		name = "<timer kasprintf failed>";
 
 	irq = bind_virq_to_irqhandler(VIRQ_TIMER, cpu, xen_timer_interrupt,
-				      IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING|IRQF_TIMER,
+				      IRQF_DISABLED|IRQF_PERCPU|
+				      IRQF_NOBALANCING|IRQF_TIMER|
+				      IRQF_FORCE_RESUME,
 				      name, NULL);
 
 	evt = &per_cpu(xen_clock_events, cpu);


