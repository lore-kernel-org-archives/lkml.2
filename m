Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab1E0HyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:54:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45886 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab1E0HyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:54:24 -0400
Date: Fri, 27 May 2011 09:54:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@alien8.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 03/12] mce-severity: cleanup severity table
Message-ID: <20110527075409.GA19300@elte.hu>
References: <4DDF21DE.9040705@jp.fujitsu.com>
 <4DDF22FA.4020406@jp.fujitsu.com>
 <20110527064647.GC16811@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527064647.GC16811@liondog.tnic>
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


* Borislav Petkov <bp@alien8.de> wrote:

> > -	BITCLR(
> > -		MCI_STATUS_VAL,
> > -		NO, "Invalid"
> > +	MCESEV(
> > +		NO, "Invalid",
> > +		BITCLR(MCI_STATUS_VAL)
> >  		),
> > -	BITCLR(
> > -		MCI_STATUS_EN,
> > -		NO, "Not enabled"
> > +	MCESEV(
> > +		NO, "Not enabled",
> > +		BITCLR(MCI_STATUS_EN)
> >  		),
> > -	BITSET(
> > -		MCI_STATUS_PCC,
> > -		PANIC, "Processor context corrupt"
> > +	MCESEV(
> > +		PANIC, "Processor context corrupt",
> > +		BITSET(MCI_STATUS_PCC)
> >  		),
> 
> I'm still wondering whether using the gcc struct assignment syntax could
> make those much more readable instead of changing the macro inclusion:
> 
> 	{
> 		.sev	= MCE_PANIC_SEVERITY,
> 		.msg	= "Processor context corrupt",
> 		.mask	= MCI_STATUS_PCC,
> 		.result	= MCI_STATUS_PCC,
> 	},
> 	...

Hidetoshi's version was already an improvement over what we have 
currently (what we have now is largely unreadable), but your variant 
looks even more readable and isnt all that much longer either.

So, the case for macros is where the initialization can be compressed 
into a single *readable* line. If that cannot be done then the least 
obfuscated version is generally the better one.

Thanks,

	Ingo
