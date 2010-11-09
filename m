Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0KIOVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:21:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab0KIOVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:21:34 -0500
Date: Tue, 9 Nov 2010 15:20:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Restrict unprivileged access to kernel syslog
Message-ID: <20101109142044.GA4473@elte.hu>
References: <1289273338.6287.128.camel@dan>
 <20101109112350.GA29800@elte.hu>
 <1289304672.6287.132.camel@dan>
 <20101109042747.3f6ab07b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109042747.3f6ab07b@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 09 Nov 2010 07:11:12 -0500
> Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> 
> > 
> > > 
> > > The initialization to zero is implicit, no need to write it out.
> > > 
> > 
> > I'll resend after the first round of comments.
> > 
> > > Also, it would also be useful to have a
> > > CONFIG_SECURITY_RESTRICT_DMESG=y option introduced by your patch as
> > > well, which flag allows a distro or user to disable unprivileged
> > > syslog reading via the kernel config.
> > 
> > Are you suggesting having the existence of the sysctl depend on 
> > CONFIG_SECURITY_RESTRICT_DMESG, or having a choice between a sysctl (when config 
> > is disabled) and having restrictions always on (when config is enabled)?
> 
> and/or have the sysctl default value depend on the config option

Yeah. I think we should have the sysctl unconditionally as in Dan's current patch - 
and make the default depend on the Kconfig setting (defaulting to off).

I.e. essentially the same as the current patch, just a bit more configurability via 
the Kconfig setting.

Thanks,

	Ingo
