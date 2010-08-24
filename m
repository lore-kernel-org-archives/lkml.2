Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0HXVzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:55:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41163 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab0HXVzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:55:41 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Tue, 24 Aug 2010 16:55:38 -0500
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Topic: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Index: ActD0dA21vjASUTxRW2mFpJqXYOnnAAA9nuA
Message-ID: <496565EC904933469F292DDA3F1663E602F0FA3AED@dlee06.ent.ti.com>
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
	<8F7AF80515AF0D4D93307E594F3CB40E4CAD39F6@dlee03.ent.ti.com>
	<496565EC904933469F292DDA3F1663E602CBDD3BB2@dlee06.ent.ti.com>
	<AANLkTimENxUjUWJQSZ1dmdkX_9hQ0pjat-kyR9oNjVxf@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3883@dlee06.ent.ti.com>
	<AANLkTi=NuPu6bvv6KF7sXRp02bvfz7oRkG1SG1PstA-H@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA397F@dlee06.ent.ti.com>
	<AANLkTinaJ=xn_CAJznVtMcA0nwK_-gbo05OQKM7PuoYA@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA3995@dlee06.ent.ti.com>
	<AANLkTinjMujus-28DcLzZ+16GAGpLohwhPhuTi5uKhB8@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F0FA39BA@dlee06.ent.ti.com>
 <AANLkTikQCTtwOkAmt3PZrOkxi=VzJtfNKGsH=YXawt9t@mail.gmail.com>
In-Reply-To: <AANLkTikQCTtwOkAmt3PZrOkxi=VzJtfNKGsH=YXawt9t@mail.gmail.com>
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

 

> -----Original Message-----
> From: Felipe Contreras [mailto:felipe.contreras@gmail.com] 
> Sent: Tuesday, August 24, 2010 4:18 PM
> To: Guzman Lugo, Fernando
> Cc: Kanigeri, Hari; linux-omap@vger.kernel.org; 
> linux-kernel@vger.kernel.org; ohad@wizery.com; 
> hiroshi.doyu@nokia.com; ameya.palande@nokia.com; 
> felipe.contreras@nokia.com
> Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
> 
> On Tue, Aug 24, 2010 at 10:30 PM, Guzman Lugo, Fernando 
> <fernando.lugo@ti.com> wrote:
> >> Oh, I actually meant the DMM pool.
> >>
> >> a) 1. Migrate to iommu, 2. Remove DMM completely
> >> b) 1. Remove DMM pool, 2. Migrate to iommu 3. Remove DMM completely
> >
> > Ok, what is the issue with DMM pool?
> 
> From what I've heard; fragmentation.
> 
> > The issue I see removing DMM pool in this moment and making all the 
> > DMM Available (from 0x11000000 to 0xFFFFFFFF omap3 case) that is:
> >
> > The DMM module allocates a list of "struct map_page" 
> elements base on 
> > DMM_POOL_SIZE to keep track of memory reserved and mapped.
> >
> > Memory allocated = DMM_POOL_SIZE / PAGE_SIZE * sizeof(struct 
> > map_page);
> >
> > So making all memory avalible it will increase the memory 
> used for DMM 
> > Module and it could be quite significant.
> >
> > Iovmm.c module, the list is increased dynamically when it 
> is needed so 
> > It does no have that problem. Then when the migration is done and 
> > Iovmm.c module is used the DMM_POOL_SIZE can be removed 
> without issues.
> 
> It seems that this "memory allocated" you are taking about is 
> an array, but what we would like is a list, like apparently 
> iovmm is using. I think I can give that a try if needed.

Yes, that is an array in dmm and a liked list in iovmm.

> 
> However, from what I can see iovmm can be used instead of dmm 
> even if the switch to iommu is not yet there.

Iovmm have a list of memory used (reserved, that is what dmm module
does) and also maps the buffer, So we can not use iovmm without removing
The mapping which is done inside dspbridge because it will conflic with
The mapping doing inside iovmm module. So that means for using iovmm, the
Mapping in dspbridge had to be removed in order to work properly.


Regards,
Fernando.

> 
> --
> Felipe Contreras
> 