Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0IMSnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:43:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59843 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0IMSnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:43:40 -0400
Date: Mon, 13 Sep 2010 20:43:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Feng Tang <feng.tang@intel.com>, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 0/4] Enabling patches of 2 early consoles for Intel
 MID platforms
Message-ID: <20100913184325.GB25367@elte.hu>
References: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
 <20100913084045.GA23741@elte.hu>
 <20100913165917.GC8509@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913165917.GC8509@kroah.com>
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


* Greg KH <greg@kroah.com> wrote:

> On Mon, Sep 13, 2010 at 10:40:45AM +0200, Ingo Molnar wrote:
> > 
> > * Feng Tang <feng.tang@intel.com> wrote:
> > 
> > > Hi all,
> > > 
> > > This serie mainly enables 2 early consoles named mrst and hsu for
> > > Intel MID platforms. please help to review, thanks,
> > > 
> > > - Feng
> > > 
> > > Changelog:
> > > 	v3:
> > > 	     * Fix a warning for mrst.h
> > > 	     * Add 2 helper funcs for fixed address mapping as
> > > 	       suggested by Ingo
> > > 	     * Rename the mrst_earlyprintk.c to early_printk_mrst.c
> > > 	     * Clean the code and fix typoes upon Ingo's comments
> > > 	v2:
> > > 	     * Code clean as suggested by Ingo 
> > 
> > Thanks, this series looks really good!
> > 
> > > Feng Tang (4):
> > >   x86, mrst: make mrst_identify_cpu() inlne inside mrst.h
> > >   x86: add two helper macros for fixed address mapping
> > >   x86, earlyprintk: add earlyprintk for Intel Moorestown platform
> > >   x86, earlyprintk: add hsu early console for Intel Medfield platform
> > > 
> > >  arch/x86/Kconfig.debug              |    4 +
> > >  arch/x86/include/asm/fixmap.h       |   15 ++
> > >  arch/x86/include/asm/mrst.h         |   10 +-
> > >  arch/x86/kernel/Makefile            |    1 +
> > >  arch/x86/kernel/early_printk.c      |   13 ++
> > >  arch/x86/kernel/early_printk_mrst.c |  319 +++++++++++++++++++++++++++++++++++
> > >  6 files changed, 361 insertions(+), 1 deletions(-)
> > >  mode change 100644 => 100755 arch/x86/include/asm/fixmap.h
> > >  create mode 100644 arch/x86/kernel/early_printk_mrst.c
> > 
> > Wrt. integration: i'd prefer to carry these four patches in the 
> > tip:x86/early-printk tree (to be merged into v2.6.37), because
> > there's some interaction with other x86 bits.
> 
> No objection from me.
> 
> > AFAICS the two serial patches:
> > 
> >  [PATCH 1/2] serial: mrst_max3110: some code cleanup
> >  [PATCH 2/2] mrst_max3110: Make the IRQ option runtime
> > 
> > Are structurally independent from the earlyprintk patches and could be 
> > carried separately in the serial tree.
> > 
> > Alan, Greg, what's your preference?
> 
> I can carry these in the tty tree fine.  They don't depend on the x86 
> patches, right?

Yeah, as far as i've checked they dont. (havent actually tested that 
tho)

Thanks,

	Ingo
