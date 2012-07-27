Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2G0Qwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:52:39 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:17982 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2G0Qwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:52:38 -0400
X-IronPort-AV: E=Sophos;i="4.77,668,1336348800"; 
   d="scan'208";a="13739578"
Date: Fri, 27 Jul 2012 17:51:40 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jan Beulich <JBeulich@suse.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: do not compile manage, balloon,
 pci, acpi and cpu_hotplug on ARM
In-Reply-To: <501258FB0200007800090DB6@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.02.1207271749420.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-10-git-send-email-stefano.stabellini@eu.citrix.com> <501258FB0200007800090DB6@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Jan Beulich wrote:
> >>> On 26.07.12 at 17:33, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > --- a/drivers/xen/Makefile
> > +++ b/drivers/xen/Makefile
> > @@ -1,11 +1,15 @@
> > -obj-y	+= grant-table.o features.o events.o manage.o balloon.o
> > +ifneq ($(CONFIG_ARM),y)
> > +obj-y	+= manage.o balloon.o
> 
> While I assume that this part (and the cpu_hotplug one below) is
> temporary, ...
> 
> > +obj-$(CONFIG_XEN_DOM0)			+= pci.o acpi.o
> 
> ... at least this one should imo be solved with a proper long term
> mechanism, i.e. the usual var-$(CONFIG_...) approach, i.e.
> 
> dom0-$(CONFIG_PCI) := pci.o
> dom0-$(CONFIG_ACPI) := acpi.o
> obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)

That's a good suggestion, thanks!
