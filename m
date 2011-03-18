Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1CRM17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:27:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1CRM1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:27:55 -0400
Subject: Re: [PATCH 1/2 v2] WARN_ON_SMP(): Allow use in if statements on UP
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>
In-Reply-To: <1300450473.16880.1476.camel@gandalf.stny.rr.com>
References: <20110317215612.566569234@goodmis.org>
	 <20110317215829.363324265@goodmis.org>  <1300439538.21794.18.camel@twins>
	 <1300450473.16880.1476.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 18 Mar 2011 13:27:29 +0100
Message-ID: <1300451249.21794.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 08:14 -0400, Steven Rostedt wrote:
> On Fri, 2011-03-18 at 10:12 +0100, Peter Zijlstra wrote:
> > On Thu, 2011-03-17 at 17:56 -0400, Steven Rostedt wrote:
> > > + * WARN_ON(!spin_is_locked(&lock)) checks, as spin_is_locked()
> > > + * returns 0 for uniprocessor settings. 
> > 
> > Arguably most spin_is_locked() usages should be removed in favour of
> > something like lockdep_assert_held().
> > 
> > The latter only emits code then built with lockdep enabled and it checks
> > we are indeed the owner, not some random other cpu.
> > 
> 
> Perhaps we should have lockdep_assert_held() also be in
> "spin_is_locked()". 

Can't since its got stronger requirements.
