Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab2J2N7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:59:37 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27066 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab2J2N7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:59:35 -0400
Date: Mon, 29 Oct 2012 09:46:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>
Subject: Re: [PATCH 01/10] xen/pvh: Support ParaVirtualized Hardware
 extensions.
Message-ID: <20121029134657.GV2708@phenom.dumpdata.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
 <1351015931-16991-2-git-send-email-konrad.wilk@oracle.com>
 <1351071465.2237.128.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351071465.2237.128.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 10:37:45AM +0100, Ian Campbell wrote:
> On Tue, 2012-10-23 at 19:12 +0100, Konrad Rzeszutek Wilk wrote:
> > diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> > index 1844d31..83050d3 100644
> > --- a/include/xen/interface/physdev.h
> > +++ b/include/xen/interface/physdev.h
> > @@ -274,6 +274,16 @@ struct physdev_dbgp_op {
> >      } u;
> >  };
> >  
> > +#define PHYSDEVOP_map_iomem        30
> > +struct physdev_map_iomem {
> > +    /* IN */
> > +    uint64_t first_gfn;
> > +    uint64_t first_mfn;
> > +    uint32_t nr_mfns;
> > +    uint32_t add_mapping; /* 1 == add mapping;  0 == unmap */
> 
> I think we would usually have map and unmap as separate ops.

Or an #define as a flag? Say:

#define PHYSDEV_MAP_IOMEM_ADD		(1<<1)
#define PHYSDEV_MAP_IOMEM_REMOVE	(1<<0)

which means that '0' is of course an invalid value and
alter the 'add_mapping' to a 'flag' value, as so:

struct physdev_map_iomem {
    /* IN */
    uint64_t first_gfn;
    uint64_t first_mfn;
    uint32_t nr_mfns;
    uint32_t flag;
}
