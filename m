Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2JPONy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:13:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6878 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab2JPONw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:13:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 16 Oct 2012 07:13:42 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "inki.dae@samsung.com" <inki.dae@samsung.com>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 16 Oct 2012 16:13:38 +0200
Subject: Re: [Linaro-mm-sig] [RFC 0/2] DMA-mapping & IOMMU - physically
 contiguous allocations
Thread-Topic: [Linaro-mm-sig] [RFC 0/2] DMA-mapping & IOMMU - physically
 contiguous allocations
Thread-Index: Ac2rqHDR/uQWbQETR7OSD0sHhPX1/w==
Message-ID: <20121016.171338.1300372057637804407.hdoyu@nvidia.com>
References: <CAAQKjZMYFNMEnb2ue2aR+6AEbOixnQFyggbXrThBCW5VOznePg@mail.gmail.com><20121016090434.7d5e088152a3e0b0606903c8@nvidia.com><CAAQKjZNQFfxpr-7dFb4cgNB2Gkrxxrswds_fSrYgssxXaqRF7g@mail.gmail.com>
In-Reply-To: <CAAQKjZNQFfxpr-7dFb4cgNB2Gkrxxrswds_fSrYgssxXaqRF7g@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Inki,

Inki Dae <inki.dae@samsung.com> wrote @ Tue, 16 Oct 2012 12:12:49 +0200:

> Hi Hiroshi,
> 
> 2012/10/16 Hiroshi Doyu <hdoyu@nvidia.com>:
> > Hi Inki/Marek,
> >
> > On Tue, 16 Oct 2012 02:50:16 +0200
> > Inki Dae <inki.dae@samsung.com> wrote:
> >
> >> 2012/10/15 Marek Szyprowski <m.szyprowski@samsung.com>:
> >> > Hello,
> >> >
> >> > Some devices, which have IOMMU, for some use cases might require to
> >> > allocate a buffers for DMA which is contiguous in physical memory. Such
> >> > use cases appears for example in DRM subsystem when one wants to improve
> >> > performance or use secure buffer protection.
> >> >
> >> > I would like to ask if adding a new attribute, as proposed in this RFC
> >> > is a good idea? I feel that it might be an attribute just for a single
> >> > driver, but I would like to know your opinion. Should we look for other
> >> > solution?
> >> >
> >>
> >> In addition, currently we have worked dma-mapping-based iommu support
> >> for exynos drm driver with this patch set so this patch set has been
> >> tested with iommu enabled exynos drm driver and worked fine. actually,
> >> this feature is needed for secure mode such as TrustZone. in case of
> >> Exynos SoC, memory region for secure mode should be physically
> >> contiguous and also maybe OMAP but now dma-mapping framework doesn't
> >> guarantee physically continuous memory allocation so this patch set
> >> would make it possible.
> >
> > Agree that the contigous memory allocation is necessary for us too.
> >
> > In addition to those contiguous/discontiguous page allocation, is
> > there any way to _import_ anonymous pages allocated by a process to be
> > used in dma-mapping API later?
> >
> > I'm considering the following scenario, an user process allocates a
> > buffer by malloc() in advance, and then it asks some driver to convert
> > that buffer into IOMMU'able/DMA'able ones later. In this case, pages
> > are discouguous and even they may not be yet allocated at
> > malloc()/mmap().
> >
> 
> I'm not sure I understand what you mean but we had already tried this
> way and for this, you can refer to below link,
>                http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg22555.html

The above patch doesn't seem to have so much platform/SoC specific
code but rather it could common over other SoC as well. Is there any
plan to make it more generic, which can be used by other DRM drivers?
