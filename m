Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2HNMqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:46:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26446 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2HNMqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:46:36 -0400
X-Authority-Analysis: v=2.0 cv=Hun06jvS c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ae7MPIGovj8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=tYNMMJoXDhy72iSMQagA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344948394.6724.3.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] preempt/hardirq.h: Clarify PREEMPT_ACTIVE bit location
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Date: Tue, 14 Aug 2012 08:46:34 -0400
In-Reply-To: <alpine.LFD.2.02.1208141216120.32033@ionos>
References: <20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com>
	 <1343706583.27983.28.camel@gandalf.stny.rr.com>
	 <502A0C19.6010007@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1208141216120.32033@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 12:18 +0200, Thomas Gleixner wrote:
> On Tue, 14 Aug 2012, Srivatsa S. Bhat wrote:
> 
> > 
> > By default, the PREEMPT_ACTIVE flag is bit 27, but different
> > architectures can override that. Update the comment to reflect
> > this fact.
> 
> Is there any sensible reason why architectures need to override that?
> I can't find one.
> 
> If there is none, then we should just remove all the overrides from
> the arch code instead. If there is a reason, then it should be
> documented.

IIRC, when I added the NMI bits to implement 'in_nmi()' I tried to make
this work across archs. But I found that bits in the preempt count have
been hard coded in assembly all over the place, and to clean it up
looked to be a nightmare.

It probably should be done, but I didn't have the time to do it then.
Perhaps we can revisit it.

In fact, looking at all the archs, I believe all archs override the
PREEMPT_ACTIVE bit, and not one of them uses the default (bit 27).

-- Steve


