Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2IQOGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:06:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:10871 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab2IQOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:06:04 -0400
X-IronPort-AV: E=Sophos;i="4.80,435,1344211200"; 
   d="scan'208";a="14582532"
Date: Mon, 17 Sep 2012 15:05:16 +0100
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
In-Reply-To: <50571289.3040509@mvista.com>
Message-ID: <alpine.DEB.2.02.1209171454480.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-12-git-send-email-stefano.stabellini@eu.citrix.com> <505374E2.5080308@mvista.com> <alpine.DEB.2.02.1209171155010.29232@kaball.uk.xensource.com>
 <50571289.3040509@mvista.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012, Sergei Shtylyov wrote:
> Hello.
> 
> On 17-09-2012 14:57, Stefano Stabellini wrote:
> 
> >>> Changes in v2:
> 
> >>> - mark Xen guest support on ARM as EXPERIMENTAL.
> 
> >>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >>> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >>> ---
> >>>   arch/arm/Kconfig |   10 ++++++++++
> >>>   1 files changed, 10 insertions(+), 0 deletions(-)
> 
> >>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> >>> index 2f88d8d..e92518d 100644
> >>> --- a/arch/arm/Kconfig
> >>> +++ b/arch/arm/Kconfig
> >>> @@ -1897,6 +1897,16 @@ config DEPRECATED_PARAM_STRUCT
> >>>   	  This was deprecated in 2001 and announced to live on for 5 years.
> >>>   	  Some old boot loaders still use this way.
> >>>
> >>> +config XEN_DOM0
> >>> +	def_bool y
> >>> +
> >>> +config XEN
> >>> +	bool "Xen guest support on ARM (EXPERIMENTAL)"
> >>> +	depends on EXPERIMENTAL && ARM && OF
> >>> +	select XEN_DOM0
> 
> >>     What's the point of selecting it if it's always "y"?
> 
> > That's because on X86 is not always "y": there are things under
> > drivers/xen that compile on both platforms and depend on XEN_DOM0.
> 
>     But we're not on x86. On ARM this select is pointless.

We need some common code (under drivers/xen) that compiles only if
XEN_DOM0 is selected, so it is not pointless after all.

XEN_DOM0 is not the only symbol that is conditionally compiled on one
architectuire and always "y" on another...
