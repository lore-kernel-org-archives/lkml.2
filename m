Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2AaObu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:31:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53877 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab2AaObu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:31:50 -0500
Date: Tue, 31 Jan 2012 15:31:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Andrew Morton <akpm@linux-foundation.org>, arjanvandeven@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: smp: Start up non-boot CPUs asynchronously
Message-ID: <20120131143130.GF13676@elte.hu>
References: <20120130205444.22f5e26a@infradead.org>
 <20120131125232.GD4408@elte.hu>
 <20120131054155.371e8307@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131054155.371e8307@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 31 Jan 2012 13:52:32 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > The real fix would be to make the init code depend less on each 
> > other, i.e. have less hotplug lock dependencies. Or, if it's 
> > such a hot lock for a good reason, why does spinning on it slow 
> > down the boot process? It really shouldnt.
> 
> by inspection, anything that calls 
> get_online_cpus()/put_online_cpus() will block while a CPU is 
> coming up. This is used in things like kmem_cache_create()... 
> which is used about everywhere. (there's various other 
> places... more or less it's a requirement for using the 
> for_each_online_cpu() api correctly)

Still magic delays are not acceptable - we want to face any 
remaining performance problems head on, we want to understand 
and fix them correctly.

Thanks,

	Ingo
