Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0IFPaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:30:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59154 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750929Ab0IFPaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:30:09 -0400
Date: Mon, 6 Sep 2010 16:48:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-14?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100906164824.339cd82e@lxorguk.ukuu.org.uk>
In-Reply-To: <4C8506B5.1040808@redhat.com>
References: <4C84B088.5050003@redhat.com>
	<1283772256.1930.303.camel@laptop>
	<4C84D1CE.3070205@redhat.com>
	<1283774045.1930.341.camel@laptop>
	<4C84D77B.6040600@redhat.com>
	<20100906124330.GA22314@elte.hu>
	<4C84E265.1020402@redhat.com>
	<20100906125905.GA25414@elte.hu>
	<4C850147.8010908@redhat.com>
	<20100906163041.3677fd66@lxorguk.ukuu.org.uk>
	<4C8506B5.1040808@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, I want the ability to terminate the code at any time and clean up 
> any resources used.  We have exactly the same requirements for ordinary 
> userspace.

So you intend to prevent its use at any point where we have a kernel only
resource held in any way manner or form ? Remember we don't hold locks or
many kinds of kernel resource across syscalls. Likewise I'm interested
how you will keep it compatible with real time ?

> > - bounded memory use
> > - trustable behaviour for access
> 
> Right.
> 
> > and usually minimal side effects since you want to optimise very
> > heavily and side effects stop that (which is also why Fortran still kicks
> > C's backside for crunching)
> >
> > Not sure you need/want to do the conversion in kernel.
> 
> I prefer bytecode as well.
> 
> > I'd have thought a
> > sane way to handle it would have been to throw stuff at the kernel in
> > some kind of semi-sane byte code that can be interpreted by a noddy
> > interpreter but firstly when you get it have the kernel try and run a
> > helper to compile it.
> 
> So you do want to jit?

Depends what you mean by jit. JIT normally implies compiling/recompiling
as you go. Do we want to compile it once at load time - probably,
assuming the tool is present.
