Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2G0Qsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:48:30 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32393 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2G0Qs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:48:29 -0400
X-IronPort-AV: E=Sophos;i="4.77,668,1336348800"; 
   d="scan'208";a="13739492"
Date: Fri, 27 Jul 2012 17:47:30 +0100
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
Subject: Re: [Xen-devel] [PATCH 06/24] xen: missing includes
In-Reply-To: <501257F30200007800090D9E@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.02.1207271739550.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-6-git-send-email-stefano.stabellini@eu.citrix.com> <501257F30200007800090D9E@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Jan Beulich wrote:
> >>> On 26.07.12 at 17:33, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > --- a/include/xen/interface/xen.h
> > +++ b/include/xen/interface/xen.h
> > @@ -10,7 +10,10 @@
> >  #define __XEN_PUBLIC_XEN_H__
> >  
> >  #include <asm/xen/interface.h>
> > +#include <linux/types.h>
> > +#ifdef CONFIG_X86
> >  #include <asm/pvclock-abi.h>
> > +#endif
> 
> Rather than hacking around this, why not clean it up:
> asm/pvclock-abi.h clearly isn't intended to be included here
> (from the perspective of the origin of xen/interface/xen.h, at
> least), nor is linux/types.h.
> 
> Or if it is really needed to deviate from the original header in
> this respect, then clearly the inclusion ought to not be arch
> specific or be moved to an arch specific header.

I think you are right: linux/types.h is not actually needed and
pvclock-abi.h should probably be included by asm/xen/interface.h.
