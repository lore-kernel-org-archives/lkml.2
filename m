Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab0EGQcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:32:09 -0400
Received: from www.tglx.de ([62.245.132.106]:53678 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159Ab0EGQcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:32:06 -0400
Date: Fri, 7 May 2010 18:30:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Ulrich Drepper <drepper@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 4/4] futex: Add FUTEX_LOCK with optional adaptive
 spinning
In-Reply-To: <1273249491.1642.360.camel@laptop>
Message-ID: <alpine.LFD.2.00.1005071829470.3401@localhost.localdomain>
References: <1273127060-30375-1-git-send-email-dvhltc@us.ibm.com>  <1273127060-30375-5-git-send-email-dvhltc@us.ibm.com>  <alpine.LFD.2.00.1005071818380.3401@localhost.localdomain> <1273249491.1642.360.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010, Peter Zijlstra wrote:

> On Fri, 2010-05-07 at 18:20 +0200, Thomas Gleixner wrote:
> > +               if (!owner->oncpu)
> 
> can't do that, that relies on __ARCH_WANT_UNLOCKED_CTXSW

Grr, yes.
 
> Please keep the code as near mutex_spin_on_owner() as possible.

There is no reason why we can't make that unconditional.

Thanks,

	tglx
