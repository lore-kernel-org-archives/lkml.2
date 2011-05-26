Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1EZLMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:12:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab1EZLMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:12:05 -0400
Date: Thu, 26 May 2011 13:11:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gleb Natapov <gleb@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
        James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526111127.GF1763@elte.hu>
References: <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <BANLkTind9dUu3=OkSjXrkmrh5ik6xxT=vw@mail.gmail.com>
 <20110526085939.GG29458@redhat.com>
 <20110526103836.GC1763@elte.hu>
 <20110526104636.GL29458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526104636.GL29458@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gleb Natapov <gleb@redhat.com> wrote:

> > In that model each process has its own stack, not accessible to 
> > other worker processes. They'd only share the guest RAM image and 
> > some (minimal) global state.
> > 
> > This way the individual devices are (optionally) isolated from 
> > each other. In a way this is a microkernel done right ;-)
> 
> But doesn't this design suffer the same problem as microkernel? 
> Namely a lot of slow IPCs?

Most of the IPCs we do already, to keep the devices separated from 
each other. So the most common type of IPC comes 'for free' in that 
model - and this is specific to virtualization so i'd not extend the 
claim to the host kernel.

virtio is an IPC mechanism to begin with.

It's certainly not entirely free though so if this is implemented in 
tools/kvm/ it should be configurable.

Thanks,

	Ingo
