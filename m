Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0DBUpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:45:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50265 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0DBUpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:45:00 -0400
Date: Fri, 2 Apr 2010 22:44:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@google.com>
Subject: Re: [RFC,PATCH 2/2] perf, x86: Utilize the LBRs for machine/oops
 debugging
Message-ID: <20100402204446.GD21840@elte.hu>
References: <20100329122021.765109681@chello.nl>
 <20100329122138.848413757@chello.nl>
 <20100329170259.GA15083@elte.hu>
 <1269882768.12097.365.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269882768.12097.365.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2010-03-29 at 19:02 +0200, Ingo Molnar wrote:
>
> > Plus, it would be nice to have a sysctl entry for this as well - so that 
> > production systems can enable this if they want to enrich the output of 
> > some difficult-to-analyze kernel crash, without yet another reboot.
> 
> Right, could do, but once it crashed it clearly to late to enable anything 
> ;-)

No. What i mean is that with your patch, a debugging session would go like 
this:

  < kernel crashes >                            # reboot #1

  < admin logs in and scratches head >
  < admin consults kernel hackers and enables lbr_debug=1 in /etc/grub.conf >

  < admin reboots >                             # reboot #2

  < kernel crashes again >                      # reboot #3

With the sysctl we'd have one reboot less:

  < kernel crashes >                            # reboot #1

  < admin logs in and scratches head >
  < admin consults kernel hackers and tweaks /proc/sys/kernel/x86/lbr_debug >

  < kernel crashes again >                      # reboot #2

Thanks,

	Ingo
