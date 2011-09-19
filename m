Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab1ISK2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 06:28:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:34686 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1ISK2K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 06:28:10 -0400
Subject: Re: [PATCH] x86: perf: Clean up perf_event cpu code
From: Peter Zijlstra <peterz@infradead.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Sep 2011 12:27:43 +0200
References: <1314704115.2799.12.camel@twins>
	 <1314747665-2090-1-git-send-email-kjwinchester@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316428063.1511.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-02 at 15:32 +0200, Peter Zijlstra wrote:
> On Tue, 2011-08-30 at 20:41 -0300, Kevin Winchester wrote:
> > The CPU support for perf events on x86 was implemented via included C files
> > with #ifdefs.  Clean this up by creating a new header file and compiling
> > the vendor-specific files as needed.
> > 
> > Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> > ---
> > 
> > This is now against the tip tree.  I left it all as one big commit for now,
> > although I can break it up if necessary.  I'm just not sure it would gain much.
> > 
> > Again, this is by far the largest out of the handful of patches I have ever
> > submitted, so please let me know if I am doing anything wrong.
> > 
> 
> I've stuck it in the queue,. seems to work so far.
> 
> If Ingo doesn't complain, it ought to show up for the next release
> someplace ;-)

Ingo found that it failed to build on i386-up, the below delta (already
folded in the patch) cured things:


---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 
 #include <asm/hardirq.h>
+#include <asm/apic.h>
 
 #include "perf_event.h"
 
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
@@ -11,6 +11,7 @@
 
 #include <asm/perf_event_p4.h>
 #include <asm/hardirq.h>
+#include <asm/apic.h>
 
 #include "perf_event.h"
 

