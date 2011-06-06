Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab1FFQBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:01:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757Ab1FFQBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:01:08 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110606155236.GA7374@elte.hu>
References: <4DEB6F3A.3000109@die-jansens.de>
	 <20110605133958.GA27812@elte.hu> <4DEB8A93.30601@die-jansens.de>
	 <20110605141003.GB29338@elte.hu> <4DEB933C.1070900@die-jansens.de>
	 <20110605151323.GA30590@elte.hu> <1307349530.2353.7374.camel@twins>
	 <20110606145827.GD30348@elte.hu> <1307372989.2322.136.camel@twins>
	 <1307375227.2322.161.camel@twins>  <20110606155236.GA7374@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 18:00:39 +0200
Message-ID: <1307376039.2322.164.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 17:52 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Needs more staring at, preferably by someone who actually 
> > understands that horrid mess :/ Also, this all still doesn't make 
> > printk() work reliably while holding rq->lock.
> 
> So, what about my suggestion to just *remove* the wakeup from there 
> and use the deferred wakeup mechanism that klogd uses.
> 
> That would make printk() *visibly* more robust in practice.

That's currently done from the jiffy tick, do you want to effectively
delay releasing the console_sem for the better part of a jiffy?

> [ It would also open up the way to possibly make printk() NMI entry 
>   safe - currently we lock up if we printk in an NMI or #MC context 
>   that happens to nest inside a printk(). ]

Well, for that to happen you also need to deal with logbuf_lock nesting.
Personally I think using printk() from NMI context is quite beyond sane.
