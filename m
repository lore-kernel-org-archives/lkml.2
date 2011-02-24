Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1BXUiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:38:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33909 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756508Ab1BXUiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:38:00 -0500
Date: Thu, 24 Feb 2011 20:40:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
Message-ID: <20110224204011.5985cf63@lxorguk.ukuu.org.uk>
In-Reply-To: <1298579452.5226.834.camel@laptop>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
	<1298573197.2428.457.camel@twins>
	<20110224201124.138311ba@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>
	<alpine.LFD.2.00.1102241522130.31831@xanadu.home>
	<1298579452.5226.834.camel@laptop>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 21:30:52 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2011-02-24 at 15:24 -0500, Nicolas Pitre wrote:
> 
> > Most SMP ARM processors are going to use it soon.  Powering down idle 
> > cores provides substantial power saving.

And some X86 will be doing likewise

> And why can't regular idle paths be used? CPU hotplug is a massively
> expensive operation.

They are not CPU idling on our idle path, they are dropping into suspend
to RAM, that means they need to drop the devices into S2R states as well.

And yes the paths are currently expensive in places but they need to be
sped up more not messed up. For most devices it's not going to be that
hard to sort out - the big ugly is x86 patching the instruction stream
back and forth each suspend/resume which is in "durrr..." category of
smartness.

