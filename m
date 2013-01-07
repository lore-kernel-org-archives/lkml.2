Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab3AGHRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:17:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:19816 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab3AGHRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:17:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="273674815"
From: "Xu, Dongxiao" <dongxiao.xu@intel.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous memory
 for map_sg hook
Thread-Topic: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous memory
 for map_sg hook
Thread-Index: AQHN3o/8QLrNznpGKUOtNpr4fAsG7pg9jZrA
Date: Mon, 7 Jan 2013 07:17:33 +0000
Message-ID: <40776A41FC278F40B59438AD47D147A90FED9A52@SHSMSX102.ccr.corp.intel.com>
References: <1354799322-6000-1-git-send-email-dongxiao.xu@intel.com>
 <20121207140852.GC3140@phenom.dumpdata.com>
 <40776A41FC278F40B59438AD47D147A90FEBE741@SHSMSX102.ccr.corp.intel.com>
 <20121211170653.GG9347@localhost.localdomain>
 <40776A41FC278F40B59438AD47D147A90FEBFB64@SHSMSX102.ccr.corp.intel.com>
 <50C85E9F02000078000AFD65@nat28.tlf.novell.com>
 <20121219200904.GG15037@phenom.dumpdata.com>
 <40776A41FC278F40B59438AD47D147A90FECC3EC@SHSMSX102.ccr.corp.intel.com>
 <50D2E0C102000078000B1B1C@nat28.tlf.novell.com>
In-Reply-To: <50D2E0C102000078000B1B1C@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Thursday, December 20, 2012 4:56 PM
> To: Xu, Dongxiao
> Cc: xen-devel@lists.xen.org; Konrad Rzeszutek Wilk;
> linux-kernel@vger.kernel.org
> Subject: RE: [Xen-devel] [PATCH] xen/swiotlb: Exchange to contiguous memory
> for map_sg hook
> 
> >>> On 20.12.12 at 02:23, "Xu, Dongxiao" <dongxiao.xu@intel.com> wrote:
> > Sorry, maybe I am still not describing this issue clearly.
> 
> No, at least I understood you the way you re-describe below.
> 
> > Take the libata case as an example, the static DMA buffer locates
> > (dev->link->ap->sector_buf , here we use Data Structure B in the graph) in
> > the following structure:
> >
> > -------------------------------------Page boundary
> > <Data Structure A>
> > <Data Structure B>
> > -------------------------------------Page boundary
> > <Data Structure B (cross page)>
> > <Data Structure C>
> > -------------------------------------Page boundary
> >
> > Where Structure B is our DMA target.
> >
> > For Data Structure B, we didn't care about the simultaneous access, either
> > lock or sync function will take care of it.
> > What we are not sure is "read/write of A and C from other processor". As we
> > will have memory copy for the pages, and at the same time, other CPU may
> > access A/C.
> 
> The question is whether what libata does here is valid in the first
> place - fill an SG list entry with something that crosses a page
> boundary and is not a compound page.

Sorry for the late response about this thread.

To make sure I understand you correctly, so do you mean the correct fix should be applied to libata driver, and make sure it DMA from/to correct place (for example, some memory allocated by DMA API), but not such certain field in a static structure?

If we fix it in device driver side, then we may not need to modify the xen-swiotlb part.

Thanks,
Dongxiao

> 
> Jan

