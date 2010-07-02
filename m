Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab0GBRDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:03:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46746 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab0GBRC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:02:58 -0400
From: "Kanigeri, Hari" <h-kanigeri2@ti.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "ohad@wizery.com" <ohad@wizery.com>,
       "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
       "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
       "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Fri, 2 Jul 2010 12:02:51 -0500
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Topic: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Index: AcsYsiGs9TjFYcgfQgej6lNQk7fClgAw2joAACMEqqAAAT/OkA==
Message-ID: <8F7AF80515AF0D4D93307E594F3CB40E4CAD39F6@dlee03.ent.ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
 <1277943660-4112-2-git-send-email-x0095840@ti.com>
 <1277943660-4112-3-git-send-email-x0095840@ti.com>
 <1277943660-4112-4-git-send-email-x0095840@ti.com>
 <1277943660-4112-5-git-send-email-x0095840@ti.com>
 <1277943660-4112-6-git-send-email-x0095840@ti.com>
 <1277943660-4112-7-git-send-email-x0095840@ti.com>
 <1277943660-4112-8-git-send-email-x0095840@ti.com>
 <1277943660-4112-9-git-send-email-x0095840@ti.com>
 <8F7AF80515AF0D4D93307E594F3CB40E4CAD34D5@dlee03.ent.ti.com>
 <496565EC904933469F292DDA3F1663E602CBDD3ADE@dlee06.ent.ti.com>
In-Reply-To: <496565EC904933469F292DDA3F1663E602CBDD3ADE@dlee06.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando,

> -----Original Message-----
> From: Guzman Lugo, Fernando
> Sent: Friday, July 02, 2010 11:27 AM
> To: Kanigeri, Hari; linux-omap@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: ohad@wizery.com; hiroshi.doyu@nokia.com; ameya.palande@nokia.com;
> felipe.contreras@nokia.com
> Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
> 
> 
> 
> Hi Hari,
> 
> > -----Original Message-----
> > From: Kanigeri, Hari
> > Sent: Thursday, July 01, 2010 6:36 PM
> > To: Guzman Lugo, Fernando; linux-omap@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Cc: ohad@wizery.com; hiroshi.doyu@nokia.com; ameya.palande@nokia.com;
> > felipe.contreras@nokia.com; Guzman Lugo, Fernando
> > Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
> >
> > Fernando,
> >
> > > -	for_each_sg(sgt->sgl, sg, sgt->nents, i)
> > > -		sg_set_page(sg, usr_pgs[i], PAGE_SIZE, 0);
> > > +		da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE |
> > > +							IOVMF_ELSZ_32);
> >
> > -- iommu_vmap does the Kernel mapping to the buffers you are mapping to
> > DSP MMU. Why do you need Kernel mappings ?
> >
> > If there is no benefit in maintaining Kernel mapping I would rather call
> > iopgtable_store_entry directly to map the entries.
> 
> Where inside iommu_vmap is the mapping done?

-- The mapping is done to track down the Device mappings. But since you already have it in dmm.c this is kind of redundant right now, and we might see performance impact due to this. 

I think it might be good to transition to iovmm when we phase out dmm.c. 
Few things to take into account transitioning to iovmm approach:
	- DSPBridge used to have linked list approach to track down the mapped entries and profiling showed it took considerable amount of traversing through the list. Jeff Taylor's algorithm in dmm.c helped to reduce this impact. 
	- How would you manage the Device virtual pool moving to iovmm ? And how about the reservation ?

Thank you,
Best regards,
Hari
