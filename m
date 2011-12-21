Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1LULXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:23:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45986 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1LULXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:23:39 -0500
Message-ID: <1324466604.10752.0.camel@twins>
Subject: Re: [RFC][PATCH 0/7] improve printk reliability
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Greg KH <greg@kroah.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 12:23:24 +0100
In-Reply-To: <20111221105739.798864333@chello.nl>
References: <20111221105739.798864333@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 11:57 +0100, Peter Zijlstra wrote:
> Hi,
> 
> So these are my current efforts to make my own console output more
> reliable. I've hit every deadlock described in this series and a few
> more.
> 
> With these patches applied I can printk() and WARN() from inside 
> scheduler context and not have my machine deadlock, even without the 
> aid of early_printk().
> 
> While I'll go an remove the sole printk() I found in the scheduler
> so that we don't have to rely on the console doing this, it is good
> to have a reliable console that can do this.
> 
> As it stands some of the patches, the semaphore one in particular,
> are really too ugly to live so I won't push those but wanted to share
> anyway.
> 
> Debugging this was 'fun', and I really hope to not have to do it
> again :-)

Also, these patches enable lockdep over printk(), allowing lockdep to
detect previously undetected deadlocks with console implementations,
irrespective of rq->lock.


