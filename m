Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab0JSLum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:50:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:52883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab0JSLul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:50:41 -0400
Subject: Re: [PATCH] perf, powerpc: Fix power_pmu_event_init to not use
 event->ctx
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Alexey Kardashevskiy <aik@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1287476932.29097.1617.camel@twins>
References: <20101019055535.GA10398@drongo>
	 <1287476932.29097.1617.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 13:50:30 +0200
Message-ID: <1287489030.1994.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 10:28 +0200, Peter Zijlstra wrote:
 
> > (The reason it needs to know whether it is a per-task event is because
> > there are some hardware events on Power systems which only count when
> > the processor is not idle, and there are some fixed-function counters
> > which count such events.  For example, the "run cycles" event counts
> > cycles when the processor is not idle.  If the user asks to count
> > cycles, we can use "run cycles" if this is a per-task event, since the
> > processor is running when the task is running, by definition.  We
> > can't use "run cycles" if the user asks for "cycles" on a system-wide
> > counter.)

Right, so the problem comes from you using run-cycles as cycles? How
does that interact with things like cpu_relax() will that generate a
difference in run-cycles vs cycles?


