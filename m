Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0KRIBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:01:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0KRIBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:01:41 -0500
Date: Thu, 18 Nov 2010 09:01:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: Jean Pihet <jean.pihet@newoldbits.com>, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: [PATCH 2/3] PERF(kernel): Cleanup power events
Message-ID: <20101118080132.GH32621@elte.hu>
References: <1289498595-25806-1-git-send-email-trenn@suse.de>
 <201011121217.11339.trenn@suse.de>
 <AANLkTim00A5V9PLP3f_enZ05xR-3VvKOR_9vvXORVPS7@mail.gmail.com>
 <201011140734.07770.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201011140734.07770.trenn@suse.de>
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


* Thomas Renninger <trenn@suse.de> wrote:

> On Friday 12 November 2010 03:50:21 pm Jean Pihet wrote:
> > On Fri, Nov 12, 2010 at 7:17 PM, Thomas Renninger <trenn@suse.de> wrote:
> ...
> > >> > +
> > >> > +#ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
> > >> > +
> > >> >  #ifndef _TRACE_POWER_ENUM_
> > >> >  #define _TRACE_POWER_ENUM_
> > >> >  enum {
> > >> > @@ -153,8 +214,32 @@ DEFINE_EVENT(power_domain, power_domain_target,
> > >> >
> > >> >        TP_ARGS(name, state, cpu_id)
> > >> >  );
> > >> > -
> > >> > +#endif /* CONFIG_EVENT_POWER_TRACING_DEPRECATED */
> > >> The clock and power_domain events have been recently introduced and so
> > >> must be part of the new API. Can this #endif be moved right after the
> > >> definition of power_end?
> > > Oops, I pulled again meanwhile and the patches still patched without fuzz,
> > > but probably with some offset.
> > > I'll look at that and resend this one.
> > Ok
> Thanks for pointing this out. Because pre-processor conditionals only have 
> been moved around it looks like my test build after pulling still succeeded,
> while the #ifdefs/#endifs were rather messed up.
> 
> I adjusted these parts and successfully test-built on quite a lot .config 
> flavors on i386, x86_64, different ppc, ia64 and s390.
> 
> > >> A string is needed here. Without it it is impossible to have the option
> > >> unset.
> > >> This does the trick: +bool "Deprecated power event trace API, to be
> > >> removed" 
> Adjusted, thanks.
> 
> > > I am currently rebuilding on several archs/flavors and hope to be able
> > > to re-send this one today or on Tue.
> Done.
> 
> @Ingo: If this does not go into x86/tip, but perf or whatever tree, it would
> be great if you can ping me as soon as this stuff is in.

Mind sending the latest version which has been adjusted/fixed and all acks added?

Thanks,

	Ingo
