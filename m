Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0ESJNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:13:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:35630 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0ESJND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:13:03 -0400
Subject: Re: [tip:perf/core] perf/ftrace: Optimize perf/tracepoint
 interaction for single events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20100519090654.GK5704@nowhere>
References: <tip-4f41c013f553957765902fb01475972f0af3e8e7@git.kernel.org>
	 <20100519075804.GF5704@nowhere> <1274257123.5605.10260.camel@twins>
	 <20100519082335.GG5704@nowhere> <1274259525.5605.10352.camel@twins>
	 <20100519090654.GK5704@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 11:12:28 +0200
Message-ID: <1274260348.5605.10379.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 11:06 +0200, Frederic Weisbecker wrote:
> On Wed, May 19, 2010 at 10:58:45AM +0200, Peter Zijlstra wrote:
> > How about something like the below?
> > 
> > 
> > ---
> > Subject: perf, trace: Remove IRQ-disable from perf/tracepoint interaction
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Wed May 19 10:52:27 CEST 2010
> > 
> > 
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> 
> 
> 
> Looks fine if we don't have nested irqs.

Well, I was thinking the per-context recursion thing would sort that
out. We can have 1 event per context in-flight.
