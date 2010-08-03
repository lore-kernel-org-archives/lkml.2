Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab0HCLZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:25:23 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60256 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab0HCLZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:25:21 -0400
Date: Tue, 3 Aug 2010 13:25:03 +0200
From: Florian Mickler <florian@mickler.org>
To: Paul Menage <menage@google.com>
Cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
        paulmck@linux.vnet.ibm.com, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100803132503.2a174695@schatten.dmk.lab>
In-Reply-To: <AANLkTikqMg+Syf3YooE9PtWD-S2nRemVcOitivUFU3OG@mail.gmail.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801204026.GH31324@thunk.org>
	<20100802030304.GU2470@linux.vnet.ibm.com>
	<20100801210548.23f77ff6@infradead.org>
	<alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm>
	<20100802074429.73a9dfd9@schatten.dmk.lab>
	<alpine.DEB.2.00.1008012303160.25170@asgard.lang.hm>
	<20100802084003.1c4c2bdb@schatten.dmk.lab>
	<20100802085332.23dd22f6@schatten.dmk.lab>
	<AANLkTikqMg+Syf3YooE9PtWD-S2nRemVcOitivUFU3OG@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, 2 Aug 2010 21:38:12 -0700
Paul Menage <menage@google.com> wrote:

> On Sun, Aug 1, 2010 at 11:53 PM, Florian Mickler <florian@mickler.org> wrote:
> >
> > Thinking about it.. I don't know much about cgroups, but I think a
> > process can only be in one cgroup at a time.
> 
> A thread can only be in one cgroup in each hierarchy at one time. You
> can mount multiple cgroups hierarchies, with different resource
> controllers on different hierarchies.
> 
> >
> > b) you can't use cgroup for other purposes anymore. I.e. if you want to
> > have 2 groups that each only have half of the memory available, how
> > would you then integrate the cgroup-ignore-for-idle-approach with this?
> 
> You could mount the subsystem that provides the "ignore-for-idle"
> support on one hierarchy, and partition the trusted/untrusted
> processes that way, and the memory controller subsystem on a different
> hierarchy, with whatever split you wanted for memory controls.
> 
> Paul

Thank you for the clarification. That renders my original objections
more or less void. 

I've still got some doubts about the flexibility of this approach (think
an open system with arbitrary software components). But with a userspace
manager that sorts processes into the groups this may be a possible
solution. 

But we should probably concentrate first on the requirements now. If we
have a set of requirements everyone can agree too, we may be on our way
to get a solution.

Cheers,
Flo
