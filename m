Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2INVcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:32:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41391 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab2INVcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:32:41 -0400
Date: Fri, 14 Sep 2012 23:32:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86: Prefer TZCNT over BFS
Message-ID: <20120914213239.GB29307@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>, mingo@kernel.org,
	hpa@zytor.com, linux-kernel@vger.kernel.org, JBeulich@suse.com,
	tglx@linutronix.de, linux-tip-commits@vger.kernel.org
References: <504DEA1B020000780009A277@nat28.tlf.novell.com>
 <tip-5870661c091e827973674cc3469b50c959008c2b@git.kernel.org>
 <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFxs3FUETs830p-ow29RDibu9=d77gxqaueX-wZyr8-40A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 02:14:57PM -0700, Linus Torvalds wrote:
> On Thu, Sep 13, 2012 at 11:23 PM, tip-bot for Jan Beulich
> <JBeulich@suse.com> wrote:
> >
> > x86: Prefer TZCNT over BFS
> 
> This patch is insane.
> 
> > For the moment, only do this when the respective generic-CPU
> > option is selected (as there are no specific-CPU options
> > covering the CPUs supporting TZCNT), and don't do that when size
> > optimization was requested.
> 
> This is pure garbage.
> 
> Anybody who thinks this:
> 
> > +#if (defined(CONFIG_X86_GENERIC) || defined(CONFIG_GENERIC_CPU)) \
> > +    && !defined(CONFIG_CC_OPTIMIZE_FOR_SIZE)
> 
> is a good idea should be shot. Don't do it.
> 
> Introduce a new CONFIG variable with a sane name, for chrissake, the
> same way we have CONFIG_X86_XADD etc. It would be logical to call it
> X86_TZCNT, wouldn't it?
> 
> And then add sane rules for that in the x86 config file. And no, the
> above is *NOT* a sane rule at all. If I read that right, it will
> enable TZCNT even for old 32-bit CPU's, for example. That's just
> f*cking insane.
> 
> Stop this kind of idiocy. The code looks bad, and the logic is pure shit too.

And the other important question is, is this even worth the complexity?
I mean "may execute that faster than 'bsf ...'" doesn't mean a lot so
can anyone remind me again why we're doing this?

Any hot paths I've missed?

Thanks.

-- 
Regards/Gruss,
    Boris.
