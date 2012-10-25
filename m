Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab2JYMjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:39:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23248 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab2JYMjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:39:01 -0400
Date: Thu, 25 Oct 2012 08:38:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4/6] xen/pvh: bootup and setup related
 changes.
Message-ID: <20121025123828.GA25640@localhost.localdomain>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
 <1350695882-12820-5-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1210221428050.2689@kaball.uk.xensource.com>
 <20121022155717.GB25200@phenom.dumpdata.com>
 <alpine.DEB.2.02.1210231406490.2689@kaball.uk.xensource.com>
 <20121023164729.0ed51a1d@mantra.us.oracle.com>
 <20121023170310.3b2a7e20@mantra.us.oracle.com>
 <20121023171051.2ed9af3c@mantra.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023171051.2ed9af3c@mantra.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Yes, I think that this version looks better
> > > 
> > > But doesn't boot:
> > > 
> > > (XEN) vmx_hybrid.c:710:d0 Dom:0 EPT violation 0x181 (r--/---), gpa
> > > 0x000000bf421e1c, mfn 0xffffffffffffffff, type 4. (XEN)
> > > p2m-ept.c:642:d0 Walking EPT tables for domain 0 gfn bf421 (XEN)
> > > p2m-ept.c:648:d0  gfn exceeds max_mapped_pfn 4b062 (XEN)
> > > vmx_hybrid.c:717:d0  --- GLA 0xffffffffff477e1c
> > > 
> > > 
> > > I'll have to debug it, or we can go back to the prev version, which
> > > I don't think is that un-pretty :).
> > > 
> > 
> > The reason being:
> > xen_set_identity_and_release_chunk():
> > NEW : > for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn;
> > pfn++) {
> > 
> > xen_pvh_identity_map_chunk():
> > OLD: for (pfn = start_pfn; pfn < end_pfn; pfn++)
> > 
> > IOW, for PVH we need to avoid testing for max_pfn_mapped, as we are
> > mapping the entire IO space. 
> 
> Also, now your counts for released and identity are off. Can we please
> go back to the way it was? 

Lets drop this patch then for right now. Can you post an alpha-RFC of your
Xen hypervisor patches so that I can wrangle the PV and PVH in the E820
code to use same paths as much as possible.
