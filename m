Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2INNDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:03:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42838 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2INNDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:03:43 -0400
Message-ID: <1347627819.2497.68.camel@hornet>
Subject: Re: [PATCH v4 21/24] arm/v2m: initialize arch_timers even if
 v2m_timer is not present
From: Pawel Moll <pawel.moll@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
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
Date: Fri, 14 Sep 2012 14:03:39 +0100
In-Reply-To: <alpine.DEB.2.02.1209141347250.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
	 <1347621207-11294-21-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1347625628.2497.65.camel@hornet>
	 <alpine.DEB.2.02.1209141347250.29232@kaball.uk.xensource.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 14 Sep 2012 13:03:40.0264 (UTC) FILETIME=[5C682680:01CD9279]
X-MC-Unique: 112091414034012801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 13:48 +0100, Stefano Stabellini wrote:
> On Fri, 14 Sep 2012, Pawel Moll wrote:
> > On Fri, 2012-09-14 at 12:13 +0100, Stefano Stabellini wrote:
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > CC: Russell King <linux@arm.linux.org.uk>
> > > CC: Pawel Moll <pawel.moll@arm.com>
> > > CC: Marc Zyngier <marc.zyngier@arm.com>
> > > ---
> > >  arch/arm/mach-vexpress/v2m.c |   11 ++++++-----
> > >  1 files changed, 6 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
> > > index 37608f2..4e567f7 100644
> > > --- a/arch/arm/mach-vexpress/v2m.c
> > > +++ b/arch/arm/mach-vexpress/v2m.c
> > > @@ -621,16 +621,17 @@ static void __init v2m_dt_timer_init(void)
> > >  
> > >  	v2m_clk_init();
> > >  
> > > -	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
> > > -	if (WARN_ON(err))
> > > -		return;
> > > -	node = of_find_node_by_path(path);
> > > -	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
> > >  	if (arch_timer_of_register() != 0)
> > >  		twd_local_timer_of_register();
> > >  
> > >  	if (arch_timer_sched_clock_init() != 0)
> > >  		versatile_sched_clock_init(v2m_sysreg_base + V2M_SYS_24MHZ, 24000000);
> > > +
> > > +	err = of_property_read_string(of_aliases, "arm,v2m_timer", &path);
> > > +	if (WARN_ON(err))
> > > +		return;
> > > +	node = of_find_node_by_path(path);
> > > +	v2m_sp804_init(of_iomap(node, 0), irq_of_parse_and_map(node, 0));
> > >  }
> > >  
> > >  static struct sys_timer v2m_dt_timer = {
> > 
> > Fair point. The alias is going to disappear anyway (I'm working on a VE
> > platform rework right now), but in case I won't get it on time for 3.7,
> > I'll make sure this one is merged instead.
> 
> Great, thanks!
> Should I leave this patch out of the Xen on ARM series for 3.7 then?

Em, I think so - it would conflict with my changes if they go in. Either
way you'll have the problem sorted in 3.7.

Paweł


