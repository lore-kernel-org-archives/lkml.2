Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2AaPUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:20:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:53085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2AaPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:20:47 -0500
Date: Tue, 31 Jan 2012 07:22:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Andrew Morton <akpm@linux-foundation.org>, arjanvandeven@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: smp: Start up non-boot CPUs asynchronously
Message-ID: <20120131072216.1ce78e50@infradead.org>
In-Reply-To: <20120131143130.GF13676@elte.hu>
References: <20120130205444.22f5e26a@infradead.org>
	<20120131125232.GD4408@elte.hu>
	<20120131054155.371e8307@infradead.org>
	<20120131143130.GF13676@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 15:31:31 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> > 
> > by inspection, anything that calls 
> > get_online_cpus()/put_online_cpus() will block while a CPU is 
> > coming up. This is used in things like kmem_cache_create()... 
> > which is used about everywhere. (there's various other 
> > places... more or less it's a requirement for using the 
> > for_each_online_cpu() api correctly)
> 
> Still magic delays are not acceptable - we want to face any 
> remaining performance problems head on, we want to understand 
> and fix them correctly.

it's not really a performance problem as it is an obvious "we have a
ton of back-to-back writers on a read-write lock that we have quite a
few readers for". Unless the writers back off a little, the readers are
going to get starved.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
