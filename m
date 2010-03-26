Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0CZQiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:38:54 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:52821 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab0CZQix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:38:53 -0400
Date: Fri, 26 Mar 2010 17:38:50 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
       Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: set_cpus_allowed_ptr
In-Reply-To: <1269597796.12097.133.camel@laptop>
Message-ID: <Pine.LNX.4.64.1003261736440.977@ask.diku.dk>
References: <1269597796.12097.133.camel@laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried the following semantic patch:

@@
expression E1,E2;
@@

- set_cpus_allowed(E1, cpumask_of_cpu(E2))
+ set_cpus_allowed_ptr(E1, cpumask_of(E2))

@@
expression E;
identifier I;
@@

- set_cpus_allowed(E, I)
+ set_cpus_allowed_ptr(E, &I)

@@
@@

+BAD(
 set_cpus_allowed(...)
+ )

I didn't get any occurrences of BAD in the output, so there seem to be 
only calls to cpumask_of_cpu and identifiers.  Looking at the result of 
grepping for set_cpus_allowed suggested the same.  Am I missing anything?

julia
