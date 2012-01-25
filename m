Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2AYUxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:53:07 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24137 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2AYUxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:53:05 -0500
Date: Wed, 25 Jan 2012 15:50:43 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Durrant <Paul.Durrant@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "ANNIE LI (annie.li@oracle.com)" <annie.li@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Regressions in v3.3-rc1 introduced by
 "xen/granttable: Grant tables V2 implementation"
Message-ID: <20120125205043.GB21284@phenom.dumpdata.com>
References: <20120125044949.GB29759@phenom.dumpdata.com>
 <20120125051253.GA15501@phenom.dumpdata.com>
 <1327485333.24561.232.camel@zakaz.uk.xensource.com>
 <291EDFCB1E9E224A99088639C4762022C80E2F0F23@LONPMAILBOX01.citrite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <291EDFCB1E9E224A99088639C4762022C80E2F0F23@LONPMAILBOX01.citrite.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F206BAE.0059,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 03:23:28PM +0000, Paul Durrant wrote:
> > -----Original Message-----
> > From: Paul Durrant
> > Sent: 25 January 2012 07:17
> > To: Ian Campbell; Konrad Rzeszutek Wilk
> > Cc: annie.li@oracle.com; xen-devel@lists.xensource.com; linux-
> > kernel@vger.kernel.org
> > Subject: RE: [Xen-devel] Regressions in v3.3-rc1 introduced by
> > "xen/granttable: Grant tables V2 implementation"
> > 
> > > -----Original Message-----
> > >
> > > On HVM for gnttab_shared we make an add_to_physmap call with
> > > XENMAPSPACE_grant_table (in gnttab_map). I don't see any support call
> > > to do something similar for the status array though and I don't see a
> > > XENMAPSPACE_* specifically for that case either in the hypervisor either.
> > >
> > 
> > There is no map-space for the status pages. To map them you use the
> > standard map space but OR a bit (top bit IIRC) into in the idx. It's a bit icky,
> > but that's how it is.
> > 
> 
> I fixed a bug in xen-unstable a few weeks back that prevented mapping of the status frames so I guess the bug is possibly due to trying to use gnttab 2 on 4.1, where this bug would hit, but failing to check the return code from the status mapping hypercall?

changeset:   24428:5b4b7e565ab8
user:        Paul Durrant <paul.durrant@citrix.com>
date:        Sun Dec 18 14:39:14 2011 +0000
summary:     Fix grant_table v2 status mapping.

changeset:   24427:931bf1105730
user:        Paul Durrant <paul.durrant@citrix.com>
date:        Sun Dec 18 14:38:32 2011 +0000
summary:     Allow VMs to query their own grant table version.


Looks like c/s 24427 needs to be in the hypervior. Hm, but that exists
in 4.1 too as 23204. Will try back-porting cs 24428 in Xen 4.1 and seeing
if that does it.
