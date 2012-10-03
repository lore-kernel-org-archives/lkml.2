Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2JCNxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:53:03 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:48525 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2JCNxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:53:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,528,1344211200"; 
   d="scan'208";a="14916885"
Date: Wed, 3 Oct 2012 14:51:59 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: point xen_start_info to a dummy struct
 for PV on HVM guests
In-Reply-To: <1349272182.650.150.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1210031450220.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com> <1349272182.650.150.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Ian Campbell wrote:
> On Wed, 2012-10-03 at 14:37 +0100, Stefano Stabellini wrote:
> > PV on HVM guests don't have a start_info page mapped by Xen, so
> > xen_start_info is just NULL for them.
> > That is problem because other parts of the code expect xen_start_info to
> > point to something valid, for example xen_initial_domain() is defined as
> > follow:
> > 
> > #define xen_initial_domain()    (xen_domain() && \
> >                  xen_start_info->flags & SIF_INITDOMAIN)
> 
> But anyone who calls this before xen_start_info is setup is going to get
> a bogus result, specifically in this case they will think they are domU
> when in reality they are dom0 -- wouldn't it be better to fix those
> callsites?

That cannot be the case because setting up xen_start_info is the very
first thing that is done, before even calling to C.


> Perhaps turn this into a static inline with a BUG_ON(!xen_start_info) to
> make catching these cases easier?

