Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0JNNYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 09:24:51 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33274 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0JNNYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 09:24:49 -0400
Subject: Re: [PATCH v3 1/7] sched: introduce primitives to account for CFS
 bandwidth tracking
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101014123834.GB13048@balbir.in.ibm.com>
References: <20101012074910.GA9893@in.ibm.com>
	 <20101012075023.GB9893@in.ibm.com>
	 <20101013130018.GC3914@balbir.in.ibm.com>
	 <1287042737.29097.153.camel@twins>
	 <20101014123834.GB13048@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 15:24:24 +0200
Message-ID: <1287062664.29097.195.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 18:08 +0530, Balbir Singh wrote:
> > > 
> > > hrtimer_start_expires(period_timer, HRTIMER_MODE_ABS_PINNED) if we
> > > don't care about wakeup_softirq, is there a reason we prefer to keep
> > > wakeup as 0?
> > 
> > You cannot do wakeups while holding the rq->lock, can you? :-)
> >
> 
> :-) Yes, given that we wakeup softirq only for the current CPU. There
> is scope for some code reuse anyway, I'll see if I can send a patch. 

Well, both Thomas and I would like hrtimer_start() and friends to return
-ETIME in this case. But that means changing all callers to cope with
that, and sweeping the tree to make that happen is like lots of work.
