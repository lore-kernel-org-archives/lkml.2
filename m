Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1LFSPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:15:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37555 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab1LFSPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:15:07 -0500
Date: Tue, 6 Dec 2011 19:13:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nick Bowler <nbowler@elliptictech.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, ben@decadent.org.uk,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, bug: Exclude
 TAINT_FIRMWARE_WORKAROUND from disabling lockdep
Message-ID: <20111206181318.GA9842@elte.hu>
References: <tip-xopopjjens57r0i13qnyh2yo@git.kernel.org>
 <20111206151345.GA22353@elliptictech.com>
 <20111206154206.441e85c6@lxorguk.ukuu.org.uk>
 <20111206174320.GA25031@elte.hu>
 <20111206175230.2c5b2ea0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206175230.2c5b2ea0@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > My primary worry is to not have lockdep active when there's 
> > binary modules in a system - can TAINT_OOT_MODULE be set but 
> > TAINT_PROPRIETARY_MODULE not set for non-GPL modules?
> 
> Yes. I imagine anyone wanting to use lockdep with binary modules
> would just lie anyway.
> 
> > If not, and if TAINT_OOT_MODULE set and TAINT_PROPRIETARY_MODULE 
> > cleared guarantees the GPL-ness of the module then i have no 
> > problem with keeping lockdep active in that case.
> 
> Insofar as nobody is making their code line about licenses.

Fair enough - so i agree that we can allow OOT_MODULE's with 
lockdep and thus revert the lockdep-disabling effect of:

 2449b8ba0745: module,bug: Add TAINT_OOT_MODULE flag for modules not built in-tree

Thanks,

	Ingo
