Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab0ELMbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 08:31:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19076 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0ELMbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 08:31:23 -0400
Date: Wed, 12 May 2010 15:34:23 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: ext Nishanth Menon <nm@ti.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Linux-OMAP <linux-omap@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       ext Tony Lindgren <tony@atomide.com>,
       ext Kevin Hilman <khilman@deeprootsystems.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       "K, Ambresh" <ambresh@ti.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "Hogander Jouni (Nokia-D/Tampere)" <jouni.hogander@nokia.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCHv5 2/3] OMAP: export OMAP info under /proc/socinfo
Message-ID: <20100512123423.GA11782@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
 <1273587331-24604-3-git-send-email-eduardo.valentin@nokia.com>
 <4BE9697F.80308@ti.com>
 <20100511165846.GA10609@besouro.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511165846.GA10609@besouro.research.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 May 2010 12:30:31.0935 (UTC) FILETIME=[E9AB38F0:01CAF1CE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 11, 2010 at 06:58:46PM +0200, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> Hello Nishanth,
> 
> On Tue, May 11, 2010 at 04:28:15PM +0200, ext Nishanth Menon wrote:
> > Eduardo Valentin had written, on 05/11/2010 09:15 AM, the following:
> > > From: Eduardo Valentin <eduardo.valentin@nokia.com>
> > > 
> > > Export OMAP name and rev under /proc/socinfo node.
> > > 
> > > Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> > > ---
> > >  arch/arm/Kconfig         |    1 +
> > >  arch/arm/mach-omap1/id.c |   31 ++++++++++++++++++++++++-------
> > >  arch/arm/mach-omap2/id.c |   32 ++++++++++++++++++++++++++------
> > >  3 files changed, 51 insertions(+), 13 deletions(-)
> > > 
> > [..]
> > 
> > > diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
> > > index 37b8a1a..b67486b 100644
> > > --- a/arch/arm/mach-omap2/id.c
> > > +++ b/arch/arm/mach-omap2/id.c
> > [..]
> > 
> > > @@ -356,7 +363,8 @@ void __init omap3_cpuinfo(void)
> > >  	}
> > >  
> > >  	/* Print verbose information */
> > > -	pr_info("%s ES%s (", cpu_name, cpu_rev);
> > > +	snprintf(socinfo, SOCINFO_SZ, "%s ES%s", cpu_name, cpu_rev);
> > > +	pr_info("%s (", socinfo);
> > >  
> > >  	OMAP3_SHOW_FEATURE(l2cache);
> > >  	OMAP3_SHOW_FEATURE(iva);
> > Just a minor comment -> is it a good idea to pushin the features to SOC 
> > info as well? currently this is being displayed at bootlog and not 
> > beyond.. might be a better approach to move it into socinfo..
> 
> Yeah. I would expect that someone would ask this. When I was writing this part
> I also thought that would be nice to just duplicate all info which is printed
> into kernel log buffer. But then I decided to proceed with only the info we are
> needing from userspace. If you think that would be useful to know those as well,
> then why not adding them.

As discussed in #linux-omap IRC channel, we agreed that it would be nice and useful
to export the OMAP FEATURES under this interface. But as the code to detect omap features is
under re-work currently, for now we are going to leave it out of this patch set.

> 
> > 
> > 
> > [..]
> > 
> > -- 
> > Regards,
> > Nishanth Menon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
