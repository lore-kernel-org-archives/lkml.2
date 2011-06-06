Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1FFRoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:44:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42223 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756618Ab1FFRoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:44:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZjcQ7Ez4Zlfu2yBF5aa+p8UGISC5hUykwKy3pLb
	/FJltQo2zQy4b6
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110606150808.GF30348@elte.hu>
References: <4DEBB05C.8090506@die-jansens.de>
	 <4DEBB3DA.8060001@die-jansens.de> <20110605172052.GA1036@elte.hu>
	 <4DEBBFF9.2030101@die-jansens.de> <20110605185957.GA3452@elte.hu>
	 <4DEBD95B.6030901@die-jansens.de> <20110605194419.GA12965@elte.hu>
	 <4DEBE3DF.70104@die-jansens.de> <1307350909.2353.7408.camel@twins>
	 <20110606150409.GE30348@elte.hu>  <20110606150808.GF30348@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 19:44:00 +0200
Message-ID: <1307382240.7490.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 17:08 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > The real fix might be to remove the lockdep_off()/on() call from 
> > printk(), that looks actively evil ... we had to hack through 
> > several layers of side-effects before we found the real bug - so 
> > it's not like the off()/on() made things more robust!
> 
> The other obvious fix would be to *remove* the blasted wakeup from 
> printk(). It's a serious debugging robustness violation and it's not 
> like the wakeup is super important latency-wise.
> 
> We *already* have a timer tick driven klogd wakeup poll routine. So i 
> doubt we'd have many problems from not doing wakeups from printk(). 
> Opinions?

Seconded!  I routinely whack that damn thing.

	-Mike

