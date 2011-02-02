Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1BBG1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 01:27:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab1BBG1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 01:27:06 -0500
Date: Wed, 2 Feb 2011 07:26:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: castet.matthieu@free.fr
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, Matthias Hopf <mhopf@suse.de>,
        rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] NX protection for kernel data : fix 32 bits S3 suspend
Message-ID: <20110202062632.GA12256@elte.hu>
References: <4D473FD5.1090903@free.fr>
 <20110201080223.GB20372@elte.hu>
 <1296566732.4d4809cc1f963@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296566732.4d4809cc1f963@imp.free.fr>
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


* castet.matthieu@free.fr <castet.matthieu@free.fr> wrote:

> Quoting Ingo Molnar <mingo@elte.hu>:
> 
> >
> > * matthieu castet <castet.matthieu@free.fr> wrote:
> >
> > >  static inline int is_kernel_text(unsigned long addr)
> > >  {
> > > +#if defined(CONFIG_X86_32) && defined(CONFIG_ACPI_SLEEP)
> > > +	/*
> > > +	 * We need to make the wakeup trampoline in first 1MB !NX
> > > +	 */
> > > +	if (addr >= PAGE_OFFSET && addr <= (PAGE_OFFSET + (1<<20)))
> > > +		return 1;
> > > +#endif
> >
> > That's pretty ugly. Why not use set_memory_x()/set_memory_nx(), and only for
> > the
> > trampoline itself? Does the whole 1MB need to be marked X?
>
> The previous code was doing that.

So why not call set_memory_x() in your patch? Mind trying that?

Thanks,

	Ingo
