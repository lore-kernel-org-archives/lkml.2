Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0IRTOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:14:54 -0400
Received: from kroah.org ([198.145.64.141]:43209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab0IRTOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:49 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:58 2010
Message-Id: <20100918191258.551425236@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lin Ming <ming.m.lin@intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [015/129] perf, x86, Pentium4: Clear the P4_CCCR_FORCE_OVF flag
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lin Ming <ming.m.lin@intel.com>

commit 8d330919927ea31fa083b5a80084dc991da813a0 upstream.

If on Pentium4 CPUs the FORCE_OVF flag is set then an NMI happens
on every event, which can generate a flood of NMIs. Clear it.

Reported-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/perf_event_p4.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -457,6 +457,8 @@ static int p4_hw_config(struct perf_even
 		event->hw.config |= event->attr.config &
 			(p4_config_pack_escr(P4_ESCR_MASK_HT) |
 			 p4_config_pack_cccr(P4_CCCR_MASK_HT));
+
+		event->hw.config &= ~P4_CCCR_FORCE_OVF;
 	}
 
 	rc = x86_setup_perfctr(event);


