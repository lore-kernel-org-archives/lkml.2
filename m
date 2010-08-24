Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab0HXTac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:30:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33254 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab0HXTa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:30:29 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Tue, 24 Aug 2010 14:30:25 -0500
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Topic: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Index: ActDwIHPm8AWw9QtR9C/hjs/UwvTrAAAHuTw
Message-ID: <496565EC904933469F292DDA3F1663E602F0FA39BA@dlee06.ent.ti.com>
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
In-Reply-To: <AANLkTinjMujus-28DcLzZ+16GAGpLohwhPhuTi5uKhB8@mail.gmail.com>
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
> Sent: Tuesday, August 24, 2010 2:14 PM
> To: Guzman Lugo, Fernando
> Cc: Kanigeri, Hari; linux-omap@vger.kernel.org; 
> linux-kernel@vger.kernel.org; ohad@wizery.com; 
> hiroshi.doyu@nokia.com; ameya.palande@nokia.com; 
> felipe.contreras@nokia.com
> Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
> 
> On Tue, Aug 24, 2010 at 10:05 PM, Guzman Lugo, Fernando 
> <fernando.lugo@ti.com> wrote:
> >> I've heard there are some problems regarding DMM, and 
> since you say 
> >> you have already done the changes, and since iommu 
> migration is not 
> >> yet ready AFAIK, it might make sense to go for option b).
> >>
> >> Anyway, thanks for the clarification :)
> >
> > But DMM is used in this momment, it is after the IOMMU 
> migration When 
> > DMM is not needed anymore. So we need to go for option a).
> 
> Oh, I actually meant the DMM pool.
> 
> a) 1. Migrate to iommu, 2. Remove DMM completely
> b) 1. Remove DMM pool, 2. Migrate to iommu 3. Remove DMM completely

Ok, what is the issue with DMM pool?

The issue I see removing DMM pool in this moment and making all the DMM
Available (from 0x11000000 to 0xFFFFFFFF omap3 case) that is:

The DMM module allocates a list of "struct map_page" elements base on
DMM_POOL_SIZE to keep track of memory reserved and mapped.

Memory allocated = DMM_POOL_SIZE / PAGE_SIZE * sizeof(struct map_page);

So making all memory avalible it will increase the memory used for DMM
Module and it could be quite significant.

Iovmm.c module, the list is increased dynamically when it is needed so
It does no have that problem. Then when the migration is done and
Iovmm.c module is used the DMM_POOL_SIZE can be removed without issues.

Regards,
Fernando.

> 
> --
> Felipe Contreras
> 