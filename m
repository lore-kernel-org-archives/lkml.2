Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0KNNeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 08:34:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab0KNNeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 08:34:13 -0500
From: Thomas Renninger <trenn@suse.de>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH 2/3] PERF(kernel): Cleanup power events
Date: Sun, 14 Nov 2010 07:34:07 -0600
User-Agent: KMail/1.9.10
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com
References: <1289498595-25806-1-git-send-email-trenn@suse.de> <201011121217.11339.trenn@suse.de> <AANLkTim00A5V9PLP3f_enZ05xR-3VvKOR_9vvXORVPS7@mail.gmail.com>
In-Reply-To: <AANLkTim00A5V9PLP3f_enZ05xR-3VvKOR_9vvXORVPS7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201011140734.07770.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 November 2010 03:50:21 pm Jean Pihet wrote:
> On Fri, Nov 12, 2010 at 7:17 PM, Thomas Renninger <trenn@suse.de> wrote:
...
> >> > +
> >> > +#ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
> >> > +
> >> >  #ifndef _TRACE_POWER_ENUM_
> >> >  #define _TRACE_POWER_ENUM_
> >> >  enum {
> >> > @@ -153,8 +214,32 @@ DEFINE_EVENT(power_domain, power_domain_target,
> >> >
> >> >        TP_ARGS(name, state, cpu_id)
> >> >  );
> >> > -
> >> > +#endif /* CONFIG_EVENT_POWER_TRACING_DEPRECATED */
> >> The clock and power_domain events have been recently introduced and so
> >> must be part of the new API. Can this #endif be moved right after the
> >> definition of power_end?
> > Oops, I pulled again meanwhile and the patches still patched without fuzz,
> > but probably with some offset.
> > I'll look at that and resend this one.
> Ok
Thanks for pointing this out. Because pre-processor conditionals only have 
been moved around it looks like my test build after pulling still succeeded,
while the #ifdefs/#endifs were rather messed up.

I adjusted these parts and successfully test-built on quite a lot .config 
flavors on i386, x86_64, different ppc, ia64 and s390.

> >> A string is needed here. Without it it is impossible to have the option
> >> unset.
> >> This does the trick: +bool "Deprecated power event trace API, to be
> >> removed" 
Adjusted, thanks.

> > I am currently rebuilding on several archs/flavors and hope to be able
> > to re-send this one today or on Tue.
Done.

@Ingo: If this does not go into x86/tip, but perf or whatever tree, it would
be great if you can ping me as soon as this stuff is in.
I want to cleanup the "double cpu_idle events" issues on top and make this
more architecture independent (throw cpu_idle events from cpuidle framework
instead of throwing very x86 specific mwait states, etc.).

Thanks,

       Thomas
