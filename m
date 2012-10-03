Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2JCNyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:54:46 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:18757 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab2JCNyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:54:44 -0400
X-IronPort-AV: E=Sophos;i="4.80,528,1344211200"; 
   d="scan'208";a="14916920"
Message-ID: <1349272482.650.151.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen: point xen_start_info to a dummy struct
 for PV on HVM guests
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 3 Oct 2012 14:54:42 +0100
In-Reply-To: <alpine.DEB.2.02.1210031450220.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1210031431080.29232@kaball.uk.xensource.com>
	 <1349272182.650.150.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1210031450220.29232@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 14:51 +0100, Stefano Stabellini wrote:
> On Wed, 3 Oct 2012, Ian Campbell wrote:
> > On Wed, 2012-10-03 at 14:37 +0100, Stefano Stabellini wrote:
> > > PV on HVM guests don't have a start_info page mapped by Xen, so
> > > xen_start_info is just NULL for them.
> > > That is problem because other parts of the code expect xen_start_info to
> > > point to something valid, for example xen_initial_domain() is defined as
> > > follow:
> > > 
> > > #define xen_initial_domain()    (xen_domain() && \
> > >                  xen_start_info->flags & SIF_INITDOMAIN)
> > 
> > But anyone who calls this before xen_start_info is setup is going to get
> > a bogus result, specifically in this case they will think they are domU
> > when in reality they are dom0 -- wouldn't it be better to fix those
> > callsites?
> 
> That cannot be the case because setting up xen_start_info is the very
> first thing that is done, before even calling to C.

On PV, yes, but you are trying to fix PVHVM here, no?

Otherwise if this is always set before calling into C then what is the
purpose of this patch?

> 
> 
> > Perhaps turn this into a static inline with a BUG_ON(!xen_start_info) to
> > make catching these cases easier?
> 


