Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1ISXbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:31:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1ISXbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:31:35 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=9yXILFS5HQAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=nL07j8xGLd1ldcTufP8A:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 1/5] x86: Remove const_udelay() caring about which
 cpu var it uses
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
In-Reply-To: <alpine.DEB.2.00.1109191650010.19059@router.home>
References: <20110919212040.745370781@goodmis.org>
	 <20110919212640.343186687@goodmis.org>
	 <alpine.DEB.2.00.1109191650010.19059@router.home>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 19 Sep 2011 19:31:32 -0400
Message-ID: <1316475092.29966.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 16:51 -0500, Christoph Lameter wrote:
> On Mon, 19 Sep 2011, Steven Rostedt wrote:
> 
> > The __const_udelay() code originally used raw_smp_processor_id()
> > in its calculations for a delaying. Probably because if it were
> > to migrate, it would take much longer to do so than the requested
> > delay.
> >
> > Switch from this_cpu_read() to __this_cpu_read() to document that
> > the read is racy and we do not care.
> 
> Is preemption disabled by all callers to __const_udelay?

Nope, because I triggered a splat with it :-) From lots of places.

-- Steve


