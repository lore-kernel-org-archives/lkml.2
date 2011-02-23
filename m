Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1BWOmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:42:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36199 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab1BWOmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 09:42:18 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=x5lYFldHaXAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VnNF1IyMAAAA:8 a=WFeUc9oR0mGRn63VL4YA:9 a=hZvR7mBFBhhRIelGOuUY33M2Pt8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <BLU0-SMTP211F39903EDACD9B7E025C96DB0@phx.gbl>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <BLU0-SMTP211F39903EDACD9B7E025C96DB0@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Feb 2011 09:42:14 -0500
Message-ID: <1298472134.7666.82.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 09:02 -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> [...]
> > +	for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1)
> > +		if (mask & 01)
> 
> Wow, octal notation! ;)

Heh

> 
> Maybe we could consider 0x1 here.

Why even the conversion? mask & 1 should be good enough.

Perhaps 1UL to match the unsigned long.

-- Steve


