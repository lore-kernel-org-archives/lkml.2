Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2INMte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:49:34 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:51406 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2INMtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:49:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,422,1344211200"; 
   d="scan'208";a="14546136"
Date: Fri, 14 Sep 2012 13:48:29 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Pawel Moll <pawel.moll@arm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v4 21/24] arm/v2m: initialize arch_timers even if v2m_timer
 is not present
In-Reply-To: <1347625628.2497.65.camel@hornet>
Message-ID: <alpine.DEB.2.02.1209141347250.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>  <1347621207-11294-21-git-send-email-stefano.stabellini@eu.citrix.com> <1347625628.2497.65.camel@hornet>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012, Pawel Moll wrote:
> On Fri, 2012-09-14 at 12:13 +0100, Stefano Stabellini wrote:
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > CC: Russell King <linux@arm.linux.org.uk>
> > CC: Pawel Moll <pawel.moll@arm.com>
> > CC: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm/mach-vexpress/v2m.c |   11 ++++++-----
> >  1 files changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
> > index 37608f2..4e567f7 100644
> > --- a/arch/arm/mach-vexpress/v2m.c
> > +++ b/arch/arm/mach-vexpress/v2m.c
> > @@ -621,16 +621,17 @@ static void __init v2m_dt_timer_init(void)
> >  
> >  	v2m_clk_init();
> >  
> > -	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
> > -	if (WARN_ON(err))
> > -		return;
> > -	node = of_find_node_by_path(path);
> > -	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
> >  	if (arch_timer_of_register() != 0)
> >  		twd_local_timer_of_register();
> >  
> >  	if (arch_timer_sched_clock_init() != 0)
> >  		versatile_sched_clock_init(v2m_sysreg_base + V2M_SYS_24MHZ, 24000000);
> > +
> > +	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
> > +	if (WARN_ON(err))
> > +		return;
> > +	node = of_find_node_by_path(path);
> > +	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
> >  }
> >  
> >  static struct sys_timer v2m_dt_timer = {
> 
> Fair point. The alias is going to disappear anyway (I'm working on a VE
> platform rework right now), but in case I won't get it on time for 3.7,
> I'll make sure this one is merged instead.

Great, thanks!
Should I leave this patch out of the Xen on ARM series for 3.7 then?
