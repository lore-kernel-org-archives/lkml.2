Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab0GAXgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:36:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52035 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab0GAXgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:36:14 -0400
From: "Kanigeri, Hari" <h-kanigeri2@ti.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "ohad@wizery.com" <ohad@wizery.com>,
       "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
       "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
       "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
       "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Date: Thu, 1 Jul 2010 18:36:06 -0500
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Topic: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Index: AcsYsiGs9TjFYcgfQgej6lNQk7fClgAw2joA
Message-ID: <8F7AF80515AF0D4D93307E594F3CB40E4CAD34D5@dlee03.ent.ti.com>
References: <1277943660-4112-1-git-send-email-x0095840@ti.com>
 <1277943660-4112-2-git-send-email-x0095840@ti.com>
 <1277943660-4112-3-git-send-email-x0095840@ti.com>
 <1277943660-4112-4-git-send-email-x0095840@ti.com>
 <1277943660-4112-5-git-send-email-x0095840@ti.com>
 <1277943660-4112-6-git-send-email-x0095840@ti.com>
 <1277943660-4112-7-git-send-email-x0095840@ti.com>
 <1277943660-4112-8-git-send-email-x0095840@ti.com>
 <1277943660-4112-9-git-send-email-x0095840@ti.com>
In-Reply-To: <1277943660-4112-9-git-send-email-x0095840@ti.com>
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

> -	for_each_sg(sgt->sgl, sg, sgt->nents, i)
> -		sg_set_page(sg, usr_pgs[i], PAGE_SIZE, 0);
> +		da = iommu_vmap(mmu, da, sgt, IOVMF_ENDIAN_LITTLE |
> +							IOVMF_ELSZ_32);

-- iommu_vmap does the Kernel mapping to the buffers you are mapping to DSP MMU. Why do you need Kernel mappings ? 

If there is no benefit in maintaining Kernel mapping I would rather call iopgtable_store_entry directly to map the entries. 

Thank you,
Best regards, Hari
