Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab0HDGM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 02:12:28 -0400
Received: from ist.d-labs.de ([213.239.218.44]:57039 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab0HDGM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 02:12:27 -0400
Date: Wed, 4 Aug 2010 08:12:09 +0200
From: Florian Mickler <florian@mickler.org>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>, paulmck@linux.vnet.ibm.com,
        Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        "Ted Ts'o" <tytso@mit.edu>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, pavel@ucw.cz,
        rjw@sisk.pl, stern@rowland.harvard.edu, swetland@google.com,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804081209.37aa1095@schatten.dmk.lab>
In-Reply-To: <alpine.DEB.2.00.1008032148210.25170@asgard.lang.hm>
References: <20100801210548.23f77ff6@infradead.org>
	<alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm>
	<20100802140933.GB2405@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm>
	<AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
	<alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm>
	<AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com>
	<alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm>
	<AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
	<alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm>
	<20100804001015.GJ2407@linux.vnet.ibm.com>
	<20100803205758.21fcf372@infradead.org>
	<alpine.DEB.2.00.1008032148210.25170@asgard.lang.hm>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 21:55:07 -0700 (PDT)
david@lang.hm wrote:

> On Tue, 3 Aug 2010, Arjan van de Ven wrote:
> 
> > On Tue, 3 Aug 2010 17:10:15 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >> OK, I'll bite...
> >>
> >>> From an Android perspective, the differences are as follows:
> >>
> >> 1.	Deep idle states are entered only if there are no runnable
> >> tasks. In contrast, opportunistic suspend can happen even when there
> >> 	are tasks that are ready, willing, and able to run.
> >
> > for "system suspend", this is an absolutely valid statement.
> > for "use suspend as idle state", it's not so clearly valid.
> > (but this is sort of a separate problem, basically the "when do we
> > freeze the tasks that we don't like for power reasons" problem,
> > which in first order is independent on what kind of idle power state
> > you pick, and discussed extensively elsewhere in this thread)
> 
> note that what I'm speculating about would never freeze some of the tasks, 
> it would run everything if anything is run, but it would not consider the 
> actions of some of the programs when deciding if it can shutdown.
> 
> so if you have all your privilaged applications in long sleeps, but still 
> have your bouncing cows running, peggng the CPU, making noise, and 
> updating the screen, the system would decide the system is 'idle' and go 
> into the 'suspend' low power state until there is a wake activity.
> 
> but if you have a privilaged application doing other stuff (say you are 
> talking on the phone, have a GPS mapping program running and giving you 
> directions, etc), the bouncing cows would continue to run and there would 
> never be an attempt to freeze them while leaving the other stuff active.
> 
> David Lang

I think the only difference between your proposition and the
current android practice is that in your scheme the partition is along
the process/task boundary (i.e. good apps vs bad apps) whereas the
android looks at actions or events or ... let's call it "stuff" and
blocks suspend whenever "stuff" needs to be done. 

The main thing is that even an process that is allowed to block suspend
doesn't do so all the time. Only when it is critical that "stuff" get's
done right away. 

One way to make an application work the same way with your scheme (as
I understand it) on android could be to split the
application into an "blocker" part, that is not part of the
"ignore-cgroup" (the "trusted" part) and another one that is in the
"ignore-cgroup" (the "untrusted" part). Whenever the untrusted part
needs to block suspend it notices the "trusted" part via ipc and the
trusted part goes into some sort of "activity loop". This looks kind of
stupid. But I bet it is what application developers are going to do if
there is no provision for a flexible runtime enable/disable "suspend
blocker".

hmmm... 

Cheers,
Flo

