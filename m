Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1FERcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 13:32:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47024 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab1FERb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 13:31:59 -0400
Date: Sun, 5 Jun 2011 19:31:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Unhide DEBUG_BUGVERBOSE when EXPERT=y, even if
 DEBUG_KERNEL=n
Message-ID: <20110605173143.GA1297@elte.hu>
References: <20110605083230.GA18260@leaf>
 <20110605093445.GA19927@elte.hu>
 <20110605170639.GA739@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605170639.GA739@leaf>
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


* Josh Triplett <josh@joshtriplett.org> wrote:

> On Sun, Jun 05, 2011 at 11:34:45AM +0200, Ingo Molnar wrote:
> > 
> > * Josh Triplett <josh@joshtriplett.org> wrote:
> > 
> > >  config DEBUG_BUGVERBOSE
> > > -	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
> > > +	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL || EXPERT
> > 
> > Well, DEBUG_KERNEL really means two things:
> > 
> >   - make more debugging options available
> >   - allow the *disabling* of existing (default-enabled) debug options
> 
> As well as one more: a quick "git grep DEBUG_KERNEL" turns up a few uses
> in actual kernel source code, to control debugging features.  Those
> should likely use separately selectable debug options, but they
> currently don't.
> 
> ~/src/linux-2.6$ find * -not -name 'Kconfig*' -not -name '*defconfig' | xargs grep -n DEBUG_KERNEL
> arch/parisc/mm/init.c:653:#ifdef CONFIG_DEBUG_KERNEL /* double-sanity-check paranoia */
> arch/powerpc/kernel/sysfs.c:229:#ifdef CONFIG_DEBUG_KERNEL
> arch/powerpc/kernel/sysfs.c:258:#endif /* CONFIG_DEBUG_KERNEL */
> arch/powerpc/kernel/sysfs.c:299:#ifdef CONFIG_DEBUG_KERNEL
> arch/powerpc/kernel/sysfs.c:328:#endif /* CONFIG_DEBUG_KERNEL */
> arch/blackfin/include/asm/entry.h:53:/* As a debugging aid - we save IPEND when DEBUG_KERNEL is on,
> arch/blackfin/include/asm/entry.h:56:# ifndef CONFIG_DEBUG_KERNEL
> arch/blackfin/include/asm/entry.h:65:# else /* CONFIG_DEBUG_KERNEL */
> arch/blackfin/include/asm/entry.h:77:# endif /* CONFIG_DEBUG_KERNEL */
> arch/blackfin/include/asm/context.S:208:#ifdef CONFIG_DEBUG_KERNEL
> drivers/usb/musb/musb_core.c:557:                * REVISIT:  do delays from lots of DEBUG_KERNEL checks

These are basically just 4 cases out of thousands of drivers, zero in 
essence. Also, none seems significant in terms of code size.

> > So i think the right solution would be to select DEBUG_KERNEL if 
> > EXPERT is enabled - this would simplify things and would allow the 
> > removal of a lot of EXPERT conditions from the debug options.
> > 
> > Ok?
> 
> I could live with that, as long as CONFIG_DEBUG_KERNEL never 
> directly enables any debugging code like it does above, and just 
> acts like CONFIG_EXPERT in hiding a pile of unnecessary options.  
> DEBUG_KERNEL should probably also have some text saying it doesn't 
> actually enable any kernel debugging on its own, once that becomes 
> true.

Yeah. I'd suggest you try that route instead of cluttering all of the 
debugging Kconfigs with || EXPERT conditions, which doesnt really 
look acceptable.

Thanks,

	Ingo
