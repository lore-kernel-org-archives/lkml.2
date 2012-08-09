Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2HIREe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:04:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38443 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2HIREc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:04:32 -0400
Date: Thu, 9 Aug 2012 12:54:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH v2 10/23] xen/arm: compile and run xenbus
Message-ID: <20120809165424.GA7220@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1208061428060.4645@kaball.uk.xensource.com>
 <1344263246-28036-10-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120807182157.GN15053@phenom.dumpdata.com>
 <50216228.7010407@tycho.nsa.gov>
 <alpine.DEB.2.02.1208081743430.21096@kaball.uk.xensource.com>
 <50229B70.3090507@tycho.nsa.gov>
 <alpine.DEB.2.02.1208081805520.21096@kaball.uk.xensource.com>
 <5022A303.709@tycho.nsa.gov>
 <alpine.DEB.2.02.1208081836050.21096@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1208081836050.21096@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Right, the original patch didn't break anything with PV domains. The case
> > it doesn't handle is an HVM initial domain with an already-running
> > Xenstore domain; I think this applies both to ARM and hybrid/PVH on x86.
> > In that case, usage would be set to LOCAL instead of HVM.
> 
> 
> Right, however if I am not mistaken there is no such thing as an HVM
> dom0 right now on x86 and hybrid/PVH is probably going to return true on
> xen_pv_domain() and false on xen_hvm_domain().

The other way around.  HVM = true, PV = false.

Mukesh, correct me if I am wrong pls.
> 
> In the ARM case, given that we don't have a start_info page, we would
> need another way to figure out whether a xenstore stub domain is already
> running, so I think we can just postpone the solution of that problem
> for now.
