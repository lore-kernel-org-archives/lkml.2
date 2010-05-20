Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0ETMpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:45:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36193 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0ETMpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:45:00 -0400
Date: Thu, 20 May 2010 14:44:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: Does anyone care about gcc 3.x support for x86 anymore?
Message-ID: <20100520124453.GC2734@elte.hu>
References: <1273135546-29690-2-git-send-email-avi@redhat.com>
 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>
 <1274213443.2485.3.camel@edumazet-laptop>
 <4BF2FF26.9050701@zytor.com>
 <1274217067.2485.9.camel@edumazet-laptop>
 <4BF308E9.4040809@zytor.com>
 <4BF46FFE.1080903@redhat.com>
 <4BF48569.7080203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF48569.7080203@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/19/2010 04:10 PM, Mauro Carvalho Chehab wrote:
> > 
> > However, if the problems are just performance/dead 
> > code removal, I would just add a big warning if 
> > someone tries to compile x86 with it. I don't like 
> > very much the idea of having different minimum gcc 
> > requirements for each architecture, except if gcc is 
> > producing a broken code.
> > 
> 
> I should clarify the problem.  The problems we have seen 
> are related to constant propagation, which causes gcc3 
> to die when there is an assembly constraint like:
> 
> 	asm("..." : : "i" (foo));
> 
> ... since "foo" isn't constant as far as it is 
> concerned.  We can put in workarounds, but it's real 
> effort to keep it alive that probably isn't well spent.
> 
> Similarly, lack of constant propagation can cause code 
> that should have been compile-time removed to still be 
> there, causing link failures.

Put in a deprecation warning first perhaps?

	Ingo
