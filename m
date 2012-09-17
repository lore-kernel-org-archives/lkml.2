Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab2IQK6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:58:21 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:35399 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636Ab2IQK6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:58:20 -0400
X-IronPort-AV: E=Sophos;i="4.80,434,1344211200"; 
   d="scan'208";a="14577137"
Date: Mon, 17 Sep 2012 11:57:19 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 12/24] xen/arm: introduce CONFIG_XEN on ARM
In-Reply-To: <505374E2.5080308@mvista.com>
Message-ID: <alpine.DEB.2.02.1209171155010.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-12-git-send-email-stefano.stabellini@eu.citrix.com> <505374E2.5080308@mvista.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012, Sergei Shtylyov wrote:
> Hello.
> 
> On 09/14/2012 03:13 PM, Stefano Stabellini wrote:
> 
> > Changes in v2:
> 
> > - mark Xen guest support on ARM as EXPERIMENTAL.
> 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/arm/Kconfig |   10 ++++++++++
> >  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 2f88d8d..e92518d 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1897,6 +1897,16 @@ config DEPRECATED_PARAM_STRUCT
> >  	  This was deprecated in 2001 and announced to live on for 5 years.
> >  	  Some old boot loaders still use this way.
> >  
> > +config XEN_DOM0
> > +	def_bool y
> > +
> > +config XEN
> > +	bool "Xen guest support on ARM (EXPERIMENTAL)"
> > +	depends on EXPERIMENTAL && ARM && OF
> > +	select XEN_DOM0
> 
>    What's the point of selecting it if it's always "y"?

That's because on X86 is not always "y": there are things under
drivers/xen that compile on both platforms and depend on XEN_DOM0.
