Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0K2WaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:30:09 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50222 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab0K2WaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:30:07 -0500
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101129135045.15aec5ed.sfr@canb.auug.org.au>
References: <20101129135045.15aec5ed.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 23:30:19 +0100
Message-ID: <1291069819.32004.493.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 13:50 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> arch/sparc/kernel/perf_event.c:1326: error: 'init_hw_perf_event' undeclared here (not in a function)
> 
> Caused by commit 004417a6d468e24399e383645c068b498eed84ad ("perf, arch:
> Cleanup perf-pmu init vs lockup-detector").
> 
> I reverted that commit for today.

Ingo, can we back-merge this?

---
 arch/sparc/kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 75c5b12..39348b1 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1323,7 +1323,7 @@ int __init init_hw_perf_events(void)
 
 	return 0;
 }
-early_initcall(init_hw_perf_event);
+early_initcall(init_hw_perf_events);
 
 void perf_callchain_kernel(struct perf_callchain_entry *entry,
 			   struct pt_regs *regs)

