Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab1GANUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:20:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43535 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab1GANT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:19:58 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=ws2KCyzbm0YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=qPJ1fmbzUYmyS83jizoA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG] kprobes crashing because of preempt count
From: Steven Rostedt <rostedt@goodmis.org>
To: ananth@in.ibm.com
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        yrl.pp-manager.tt@hitachi.com
In-Reply-To: <20110701130313.GA10935@in.ibm.com>
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>
	 <4E0D1EE3.6080607@hitachi.com> <20110701113626.GB23752@in.ibm.com>
	 <4E0DB6FC.20904@hitachi.com>  <20110701130313.GA10935@in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jul 2011 09:19:55 -0400
Message-ID: <1309526395.26417.146.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 18:33 +0530, Ananth N Mavinakayanahalli wrote:
> On Fri, Jul 01, 2011 at 09:01:00PM +0900, Masami Hiramatsu wrote:
> > 
> > Yeah, it seems that same thing is done on arm too. And I'm sure that
> > However, I'm still not sure that entire int3 exec path can run without
> > calling inc_preempt_count.
> > It seems that the function is very primitive, and I doubt we can
> > allow to put kprobes on that...
> 
> Right. I think all preempt manipulation routines need to be __kprobes.
> 

As I stated earlier, it can be triggered on just a read of preempt
count. I would also hate to force preempt_count() reads and updates to
be function calls (that's the only way to make it __kprobes). The
inc/dec preempt count routines are only function calls if debug preempt
or preempt tracing is enabled, which is not the case on most distros.

Not to mention, I think reading the value of preempt count by kprobes is
a legit use case.

> Also, Steve is testing the -rt tree where artefacts related to
> locking/preemption are possibly quite different from the mainline that
> may also be at play here.

Yes, I noticed this first on an -rt variant. But I'm actually testing
patches to move from -rt to mainline. This happens to be more a mainline
issue. Once I noticed this bug, all my tests afterward was based on
v3.0-rc5.

-- Steve


