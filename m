Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3AINuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:50:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25907 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab3AINuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:50:08 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=S0zgfAou480A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=-V7fij46oSQA:10 a=ZA--uN9DVAt-reQvpiUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357739406.5190.54.camel@gandalf.local.home>
Subject: Re: [PATCH 03/33] cputime: Generic on-demand virtual cputime
 accounting
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 09 Jan 2013 08:50:06 -0500
In-Reply-To: <1357739175.5190.53.camel@gandalf.local.home>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	 <1357610913-1080-4-git-send-email-fweisbec@gmail.com>
	 <1357739175.5190.53.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 08:46 -0500, Steven Rostedt wrote:
>   
> > +config VIRT_CPU_ACCOUNTING_GEN
> > +	bool "Full dynticks CPU time accounting"
> > +	depends on HAVE_CONTEXT_TRACKING
> > +	select VIRT_CPU_ACCOUNTING
> > +	select CONTEXT_TRACKING
> 
> 	select CONTEXT_TRACKING_FORCE
> 
> Otherwise the user time never gets updated.
> 

Bah, kernel time is now screwed up with this:


# time /work/c/kernelspin 5

real    0m5.001s
user    0m1.785s
sys     0m0.000s


-- Steve


