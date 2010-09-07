Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab0IGPhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:37:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59875 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757593Ab0IGPhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:37:32 -0400
Date: Tue, 7 Sep 2010 16:55:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-14?B?RnLpZOlyaWM=?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100907165538.295db171@lxorguk.ukuu.org.uk>
In-Reply-To: <20100907034417.GA14046@elte.hu>
References: <1283772256.1930.303.camel@laptop>
	<4C84D1CE.3070205@redhat.com>
	<1283774045.1930.341.camel@laptop>
	<4C84D77B.6040600@redhat.com>
	<20100906124330.GA22314@elte.hu>
	<4C84E265.1020402@redhat.com>
	<20100906125905.GA25414@elte.hu>
	<4C850147.8010908@redhat.com>
	<20100906154737.GA4332@elte.hu>
	<4C852B2A.2030103@redhat.com>
	<20100907034417.GA14046@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Safety of #1 (x86 bytecode passed in by untrusted user-space, verified 
> and saved by the kernel and executed natively as an x86 function if it 
> passes the security checks) is trivial but obviously needs quite a bit 
> of work.

Hardly trivial - and it will always be buggy.

As well as the fact your interpreter is going to have bugs its also no
longer portable. If you have a sane input code and verify that then
compile it you get portability and verifiability.

> > Can you point me to any research?
> 
> Nope, havent seen this 'safe native x86 bytecode' idea 
> mentioned/researched anywhere yet.

Its been done as a linux arch experiment using a trusted assembler.

> I think some Java-like bytecode is roughly the same amount of conceptual 
> work as an x86 bytecode verifier, with the big disadvantage that even 
> with a JIT it's much slower [and a JIT is far from simple] - not to 
> mention the non-technical complications of Java.

The Java JIT is horrible. A better intermediate with compiler available
looks more promising. How about the qemu or valgrind intermediates ?

> 
> > I have a truly marvellous patch that fixes the bug which this 
> > signature is too narrow to contain.
> 
> Make sure you write down a short but buggy version of the patch on the 
> margin of a book. Pass on the book to your heirs and enjoy the centuries 
> long confusion from the heavens.

I'm sure the perl version will fit ;)

Alan
