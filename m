Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0C2RMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:12:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:48159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0C2RMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:12:52 -0400
Subject: Re: [RFC,PATCH 2/2] perf, x86: Utilize the LBRs for machine/oops
 debugging
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@google.com>
In-Reply-To: <20100329170259.GA15083@elte.hu>
References: <20100329122021.765109681@chello.nl>
	 <20100329122138.848413757@chello.nl>  <20100329170259.GA15083@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 19:12:48 +0200
Message-ID: <1269882768.12097.365.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 19:02 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > The LBRs are relatively cheap to keep enabled and provide some history to 
> > OOPSen, also some CPUs are reported to keep them over soft-reset, which 
> > allows us to use them to debug things like tripple faults.
> > 
> > Therefore introduce a boot option: lbr_debug=on, which always enable the 
> > LBRs and will print the LBRs on CPU init and die().
> 
> Yummie!
> 
> Have you got some sample lbr_debug=1 output as well by any chance, with a 
> crash provoked somewhere? How good is the output in practice? (i.e. how many 
> artificial entries do we have at the end of the buffer, filled with crash 
> related addresses?)

lbr_debug=on actually, =1 doesn't parse. I had some output, but I was
still looking at finding out why my %pF formats for CPU0 didn't have
symbols in, probably a init sequence issue.

> Also, i think we should use something more descriptive than lbr_debug=y. 
> Perhaps crash_trace=1 or so?

Well, I would like to keep LBR in the name, since that is the mechanism
used, we could maybe do lbr_trace or somesuch?

> Plus, it would be nice to have a sysctl entry for this as well - so that 
> production systems can enable this if they want to enrich the output of some 
> difficult-to-analyze kernel crash, without yet another reboot.

Right, could do, but once it crashed it clearly to late to enable
anything ;-)

