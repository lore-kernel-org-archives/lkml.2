Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab1ITP12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:27:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:40300 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1ITP11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:27:27 -0400
Date: Tue, 20 Sep 2011 17:27:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@gentwo.org>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <alpine.DEB.2.00.1109200947100.8056@router.home>
Message-ID: <alpine.LFD.2.02.1109201703560.2723@ionos>
References: <20110919212040.745370781@goodmis.org> <20110919212640.688732950@goodmis.org> <alpine.DEB.2.00.1109191657150.19059@router.home> <alpine.LFD.2.02.1109201334590.2723@ionos> <alpine.DEB.2.00.1109200947100.8056@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Christoph Lameter wrote:
> On Tue, 20 Sep 2011, Thomas Gleixner wrote:
> > This allows us to do proper analysis of this_cpu usage and makes the
> > code understandable.
> 
> Not sure what you want to check in this_cpu_xx operations. Why could
> there be issues with this_cpu_xx operations?

I want to get rid of them alltogether. They are crap by design and
prone to be used wrong without a sensible way to detect that.
 
> I see that __this_cpu_xx operations may not work as intended in
> preemptable contexts and there we could have more changes.
> 
> this_cpu ops are single instructions that do not guarantee any consistency
> with other this_cpu_ops. If you want consistency (same per cpu area data)
> then preemption needs to be disabled.

Right, and that's the main problem. We have no fricking way to debug
this, so they should have never been there in the first place. And you
simply CANNOT prevent people from getting this wrong w/o proper
debugging and annotation. Even YOU and Tejun made bogus conversion w/o
noticing, but you expect that others get it right?

So stop defending that trainwreck and help out with fixing the mess
you created in a proper and debugable way!

Thanks,

	tglx
