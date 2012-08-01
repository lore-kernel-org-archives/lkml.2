Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab2HAPvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:51:19 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:25461 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab2HAPvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:51:18 -0400
X-IronPort-AV: E=Sophos;i="4.77,694,1336348800"; 
   d="scan'208";a="13807442"
Date: Wed, 1 Aug 2012 16:50:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 08/24] xen/arm: Introduce xen_pfn_t for pfn and mfn
 types
In-Reply-To: <20120801142249.GF7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208011646560.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-8-git-send-email-stefano.stabellini@eu.citrix.com> <20120801142249.GF7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 26, 2012 at 04:33:50PM +0100, Stefano Stabellini wrote:
> > All the original Xen headers have xen_pfn_t as mfn and pfn type, however
> > when they have been imported in Linux, xen_pfn_t has been replaced with
> > unsigned long. That might work for x86 and ia64 but it does not for arm.
> 
> How come?

see below

> > Bring back xen_pfn_t and let each architecture define xen_pfn_t as they
> > see fit.
> 
> I am OK with this as long as your include a comment in both of the
> interface.h saying why this is needed. I am curious why 'unsinged long'
> won't work? Is it b/c on ARM you always want a 64-bit type?

Yes, we would like to make the same interface work for 32 and 64
bit guests, without any need for a "compat layer" as we currently have
on x86.
In fact I am going to add another patch to explicitly size all the
other unsigned long that we have in the public interface.
