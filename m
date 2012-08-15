Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2HOK6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:58:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54340 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2HOK6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:58:44 -0400
Message-ID: <1345028307.31459.80.camel@twins>
Subject: Re: [PATCHSET] timer: clean up initializers and implement irqsafe
 timers
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 15 Aug 2012 12:58:27 +0200
In-Reply-To: <20120815001805.GH25632@google.com>
References: <1344449428-24962-1-git-send-email-tj@kernel.org>
	 <20120813233520.GG25632@google.com>
	 <alpine.LFD.2.02.1208142055260.32033@ionos>
	 <20120814192203.GY25632@google.com>
	 <alpine.LFD.2.02.1208142243500.32033@ionos>
	 <20120814215632.GE25632@google.com>
	 <alpine.LFD.2.02.1208150005090.32033@ionos>
	 <20120814230100.GF25632@google.com>
	 <alpine.LFD.2.02.1208150116570.32033@ionos>
	 <20120815001805.GH25632@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 17:18 -0700, Tejun Heo wrote:
> Let's see if we can agree on the latter point first.  Do you agree
> that it wouldn't be a good idea to implement relatively complex timer
> subsystem inside workqueue? 

RB-trees are fairly trivial to use, but can we please get back to why
people want to do del/mod delayed work from IRQ context?

I can get the queueing part, but why do they need to cancel and or
modify stuff?

Trying to come up with a solution to a problem you don't understand is
kinda difficult.
