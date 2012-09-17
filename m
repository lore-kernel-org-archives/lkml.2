Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2IQORc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:17:32 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53331 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab2IQORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:17:31 -0400
X-IronPort-AV: E=Sophos;i="4.80,435,1344211200"; 
   d="scan'208";a="14582830"
Date: Mon, 17 Sep 2012 15:16:44 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 12/24] xen/arm: introduce CONFIG_XEN on ARM
In-Reply-To: <20120917140232.GA11996@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1209171515420.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-12-git-send-email-stefano.stabellini@eu.citrix.com> <505374E2.5080308@mvista.com> <alpine.DEB.2.02.1209171155010.29232@kaball.uk.xensource.com> <50571289.3040509@mvista.com>
 <20120917140232.GA11996@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, Sep 17, 2012 at 04:07:37PM +0400, Sergei Shtylyov wrote:
> > Hello.
> > 
> > On 17-09-2012 14:57, Stefano Stabellini wrote:
> > 
> > >>>Changes in v2:
> > 
> > >>>- mark Xen guest support on ARM as EXPERIMENTAL.
> > 
> > >>>Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > >>>Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > >>>---
> > >>>  arch/arm/Kconfig |   10 ++++++++++
> > >>>  1 files changed, 10 insertions(+), 0 deletions(-)
> > 
> > >>>diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > >>>index 2f88d8d..e92518d 100644
> > >>>--- a/arch/arm/Kconfig
> > >>>+++ b/arch/arm/Kconfig
> > >>>@@ -1897,6 +1897,16 @@ config DEPRECATED_PARAM_STRUCT
> > >>>  	  This was deprecated in 2001 and announced to live on for 5 years.
> > >>>  	  Some old boot loaders still use this way.
> > >>>
> > >>>+config XEN_DOM0
> > >>>+	def_bool y
> > >>>+
> > >>>+config XEN
> > >>>+	bool "Xen guest support on ARM (EXPERIMENTAL)"
> > >>>+	depends on EXPERIMENTAL && ARM && OF
> 
> I think the CONFIG_EXPERIMENTAL is going away. Or it has already
> gone away?

I would like to keep it for Linux v3.6, because the Xen ABI offered by
Xen 4.2 hasn't been declared stable yet.
