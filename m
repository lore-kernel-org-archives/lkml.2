Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab1EaTFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:05:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1EaTFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:05:00 -0400
Date: Tue, 31 May 2011 21:04:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20110531190436.GA22173@elte.hu>
References: <20110531163022.GA15435@elte.hu>
 <1306859709.20175.27.camel@Joe-Laptop>
 <20110531181650.GA1854@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531181650.GA1854@gere.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> On Tue, May 31, 2011 at 09:35:09AM -0700, Joe Perches wrote:
> > On Tue, 2011-05-31 at 18:30 +0200, Ingo Molnar wrote:
> > > diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> > []
> > > @@ -642,7 +642,7 @@ static int __init idle_setup(char *str)
> > >  		boot_option_idle_override = IDLE_POLL;
> > >  	} else if (!strcmp(str, "mwait")) {
> > >  		boot_option_idle_override = IDLE_FORCE_MWAIT;
> > > -		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
> > > +		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\"\n");
> > 
> > Extra quote at end.  More likely you want:
> > 
> > 		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\n");
> 
> Crap, there's no fixing this string :)
> 
> Reportedly, there's another fix from Len:
> 
> lkml.kernel.org/r/20110531101934.2737dc90.sfr@canb.auug.org.au
> 
> which is more complete. Ingo, you could drop this one.

Well, the primary problem, which needed x86/urgent treatment, was the 
annoying build warning affecting all users.

The message itself is exceedingly rare, so we can fix it via lower 
prio pathways.

Len, a small detail: mind resolving the conflict once it occurs by 
dropping the \" but keeping the \n? Your commit:

  8a27ef90237f: x86 idle: fix build warning for WARN_ONCE("idle=mwait")

removes the \n from the end of a printk-alike string - we generally 
keep the \n even though WARN_*() will accept \n-less strings.

Thanks,

	Ingo
