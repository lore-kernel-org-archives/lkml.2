Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab1AFJQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:16:34 -0500
Received: from smtp.citrix.com ([66.165.176.89]:23494 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab1AFJQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:16:33 -0500
X-IronPort-AV: E=Sophos;i="4.60,282,1291611600"; 
   d="scan'208";a="11807596"
Subject: Re: [PATCH 01/11] xen: define gnttab_set_map_op/unmap_op
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <20110105202521.GG29993@dumpdata.com>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
	 <1292420446-3348-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20110105202521.GG29993@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 6 Jan 2011 09:16:30 +0000
Message-ID: <1294305390.3831.3593.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 20:25 +0000, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 15, 2010 at 01:40:36PM +0000, stefano.stabellini@eu.citrix.com wrote:

> > +static inline void
> > +gnttab_set_map_op(struct gnttab_map_grant_ref *map, phys_addr_t addr,
> > +		  uint32_t flags, grant_ref_t ref, domid_t domid)
> > +{
> > +	if (flags & GNTMAP_contains_pte)
> > +		map->host_addr = addr;
> > +	else if (xen_feature(XENFEAT_auto_translated_physmap))
> > +		map->host_addr = __pa(addr);
> > +	else
> > +		map->host_addr = addr;
> 
> Why not just get rid of the "flags & GNTMAP_contains_pte"? If
> that returns false you still end up setting map->host_addr to addr.

That would behave differently if
xen_feature(XENFEAT_auto_translated_physmap) were true.

Ian.


