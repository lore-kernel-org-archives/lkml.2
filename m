Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1CRMOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:14:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1CRMOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:14:36 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=4eALSlNXjPcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_8WHtZ0Gm0pIa7KuC38A:9 a=nSk_6Lzydzlfz-0wSlAB8ZaFgdMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2 v2] WARN_ON_SMP(): Allow use in if statements on UP
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Darren Hart <dvhart@linux.intel.com>
In-Reply-To: <1300439538.21794.18.camel@twins>
References: <20110317215612.566569234@goodmis.org>
	 <20110317215829.363324265@goodmis.org>  <1300439538.21794.18.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 18 Mar 2011 08:14:33 -0400
Message-ID: <1300450473.16880.1476.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 10:12 +0100, Peter Zijlstra wrote:
> On Thu, 2011-03-17 at 17:56 -0400, Steven Rostedt wrote:
> > + * WARN_ON(!spin_is_locked(&lock)) checks, as spin_is_locked()
> > + * returns 0 for uniprocessor settings. 
> 
> Arguably most spin_is_locked() usages should be removed in favour of
> something like lockdep_assert_held().
> 
> The latter only emits code then built with lockdep enabled and it checks
> we are indeed the owner, not some random other cpu.
> 

Perhaps we should have lockdep_assert_held() also be in
"spin_is_locked()". The warning with spin_is_locked() is still nice to
have because it can trigger on production systems that might find a code
path that it's not locked. lockdep is too heavy to run on production
systems. But if lockdep is enabled, the spin_is_locked() should probably
check ownership too.

-- Steve


