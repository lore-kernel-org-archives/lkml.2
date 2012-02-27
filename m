Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2B0JbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:31:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44305 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2B0JbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:31:09 -0500
Message-ID: <1330335058.11248.37.camel@twins>
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Venki Pallipadi <venki@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Feb 2012 10:30:58 +0100
In-Reply-To: <20120227090819.GB1112@zhy>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	 <1329989454.24994.57.camel@twins>
	 <CABeCy1a0U8Hk3Yfp54M-U80t2fbPrFQw=GnNQ_V082e9VxJQow@mail.gmail.com>
	 <20120224054150.GA17543@zhy> <20120224061350.GB17543@zhy>
	 <1330331881.11248.28.camel@twins> <20120227090819.GB1112@zhy>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 17:08 +0800, Yong Zhang wrote:
> On Mon, Feb 27, 2012 at 09:38:01AM +0100, Peter Zijlstra wrote:
> > On Fri, 2012-02-24 at 14:13 +0800, Yong Zhang wrote:
> > 
> > > This remind me that we should have moved the irq_enter()/irq_exit() to
> > > each arch's related irq handler.
> > > see: http://marc.info/?l=linux-kernel&m=130709505700821&w=2
> > > 
> > > So Peter, is there someone alread on it? or it still worth doing now?
> > 
> > trouble was that some people didn't feel comfortable adding that
> > overhead to plain resched IPIs that didn't need to do anything.
> 
> Any ideas on where the plain resched IPIs come from?

remote wakeups that don't queue I guess. 

IIRC I looked at it a while back and while not in the majority there
were still a few (I only added counters, didn't look where they came
from).

However since 518cd623 there'd be a lot more I guess..

Feel free to investigate. Also, some non-sched users of the resched ipi
exist, eg. KVM uses it to kick a remote vcpu out from guest mode.
