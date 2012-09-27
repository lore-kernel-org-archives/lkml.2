Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2I0Rip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:38:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:46029 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2I0Rin convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:38:43 -0400
Message-ID: <1348767498.3292.29.camel@twins>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Thu, 27 Sep 2012 19:38:18 +0200
In-Reply-To: <alpine.DEB.2.02.1209270935080.5162@asgard.lang.hm>
References: <1348505683.11847.111.camel@twins>
	  <1348511193.6951.44.camel@marge.simpson.net>
	  <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
	  <20120924192056.GB4082@liondog.tnic>
	  <1348538258.7100.23.camel@marge.simpson.net>
	  <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
	  <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
	  <20120925170058.GC30158@x1.osrc.amd.com>
	  <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
	 <20120926163233.GA5339@x1.osrc.amd.com>
	  <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
	 <1348734104.3292.5.camel@twins>
	 <alpine.DEB.2.02.1209270935080.5162@asgard.lang.hm>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 09:48 -0700, david@lang.hm wrote:
> I think you are bing too smart for your own good. you don't know if it's 
> best to move them further apart or not. 

Well yes and no.. You're right, however in general the load-balancer has
always tried to not use (SMT) siblings whenever possible, in that regard
not using an idle sibling is consistent here.

Also, for short running tasks the wakeup balancing is typically all we
have, the 'big' periodic load-balancer will 'never' see them, making the
multiple moves argument hard.

Measuring resource contention on the various levels is a fun research
subject, I've spoken to various people who are/were doing so, I've
always encouraged them to send their code just so we can see/learn, even
if not integrate, sadly I can't remember ever having seen any of it :/

And yeah, all the load-balancing stuff is very near to scrying or
tealeaf reading. We can't know all current state (too expensive) nor can
we know the future.

That said, I'm all for less/simpler code, pesky benchmarks aside ;-)
