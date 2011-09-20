Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab1ITQHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:07:31 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:27233 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752208Ab1ITQHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:07:30 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: urmHFAUVM1mJ4wTTrV.pLcrUo2XVYn7u6OVH.LhE.Cr318s
 4GH8HzJAcEkHOILr2Cd3twIHN4rg8bvnCujETcXWgfo2rBn1AZ8mMuVjL16y
 wY0uXVvD9zTG28zWB.2mLQaAg_k7VwpDYan893rTVpQLUXbV1EpzFSM1wjih
 BPGGaJfyqbZqSATYxjebS3pnSiiWLdIJRY3yuP_os8zyjnXSimx_pOvLLTw6
 MVuZnPjass2IWEaGBT7F44D_mnzw7Iyhk68i2mnvtYNwxNRs9Mhp5cbDVxbm
 5Ik2e37n84q6vSQIX1NPjsEYhIbZZAI5YzW38y_P0A50J_5mrgnclCixqTRK
 cPldLe7ajJNXKXcoE0wt1MYMkClhCQYeO8fXhXwgammElPKc-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 11:07:27 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <1316534608.29966.81.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1109201105380.8056@router.home>
References: <20110919212040.745370781@goodmis.org>  <20110919212640.688732950@goodmis.org>  <alpine.DEB.2.00.1109191657150.19059@router.home>  <alpine.LFD.2.02.1109201334590.2723@ionos>  <alpine.DEB.2.00.1109200947100.8056@router.home> 
 <1316531505.29966.57.camel@gandalf.stny.rr.com>  <alpine.DEB.2.00.1109201055470.8056@router.home> <1316534608.29966.81.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Steven Rostedt wrote:

> > NO!! This defeats the whole purpose of this_cpu_ops and make the whole
> > scheme utterly useless.
>
> The thing is, the whole purpose was broken to begin with. Defeating a
> broken design is a good thing!

So then we are not allowed to use segment prefixes in core code to avoid
preempt enable disable? And to avoid interrupt disabling enabling in
critical allocator sections?

> > There are trivial cases like counter increments that are not a problem at
> > all. Most use cases are those. More complex ones can be developed to avoid
> > various overhead in performance critical sections of the kernel.
> >
>
> And adding a preempt_disable; this_cpu_inc(); preempt_enable; is not a
> bad thing either.

It defeats the purpose of the whole thing.

> What benchmarks do you have that shows this helped in anything????

The various patchsets that went into the kernel had benchmarks results.

