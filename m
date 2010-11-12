Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab0KLSRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:17:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab0KLSRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:17:19 -0500
From: Thomas Renninger <trenn@suse.de>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH 2/3] PERF(kernel): Cleanup power events
Date: Fri, 12 Nov 2010 12:17:10 -0600
User-Agent: KMail/1.9.10
Cc: mingo@elte.hu, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com
References: <1289498595-25806-1-git-send-email-trenn@suse.de> <1289498595-25806-3-git-send-email-trenn@suse.de> <AANLkTi=PdncRr8Yst03rZSPzbH3Saq-97e0H6AKDMjwg@mail.gmail.com>
In-Reply-To: <AANLkTi=PdncRr8Yst03rZSPzbH3Saq-97e0H6AKDMjwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201011121217.11339.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 November 2010 08:20:47 am Jean Pihet wrote:
> Thomas,
...
> > +
> > +       TP_printk("state=%lu cpu_id=%lu", (unsigned long)__entry->state,
> > +                 (unsigned long)__entry->cpu_id)
> Using %lu for the state field causes PWR_EVENT_EXIT to appear as
> 4294967295 instead of -1. Can the field be of a signed type?
This is intended, what exactly is the problem?
 
...
> > +       TP_printk("state=%lu", (unsigned long)__entry->state)
> Same remark about the unsigned type for the state field.
Same.
> 
> > +);
> > +
> > +#ifdef CONFIG_EVENT_POWER_TRACING_DEPRECATED
> > +
> >  #ifndef _TRACE_POWER_ENUM_
> >  #define _TRACE_POWER_ENUM_
> >  enum {
> > @@ -153,8 +214,32 @@ DEFINE_EVENT(power_domain, power_domain_target,
> >
> >        TP_ARGS(name, state, cpu_id)
> >  );
> > -
> > +#endif /* CONFIG_EVENT_POWER_TRACING_DEPRECATED */
> The clock and power_domain events have been recently introduced and so
> must be part of the new API. Can this #endif be moved right after the
> definition of power_end?
Oops, I pulled again meanwhile and the patches still patched without fuzz,
but probably with some offset.
I'll look at that and resend this one.

> >  #endif /* _TRACE_POWER_H */
> Should this be at the very end of the file?
Not sure whether this also came from merge issues, but yes, several
#ifdef conditions need to get corrected.

...

> A string is needed here. Without it it is impossible to have the option
> unset. 
> This does the trick: +bool "Deprecated power event trace API, to be removed"
Ok, thanks.

I am currently rebuilding on several archs/flavors and hope to be able
to re-send this one today or on Tue.

Thanks,

    Thomas
