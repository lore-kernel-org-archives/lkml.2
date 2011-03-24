Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab1CXNgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:36:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1CXNgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:36:45 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=4eALSlNXjPcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8xq8cGDoETOYwtL_BDIA:9 a=FjL6vj5dN8WoxxguhYQy7hC88jYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
Date: Thu, 24 Mar 2011 09:36:42 -0400
Message-ID: <1300973802.14261.140.camel@gandalf.stny.rr.com>
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

Without going into the issue that spin_is_locked() should go into the
lockdep category, and we should restructure every user of it to use
lockdep instead...

Peter, for the immediate fix (eg. this merge window), can I have your
acked-by for this patch?

Thanks,

-- Steve


