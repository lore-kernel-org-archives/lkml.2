Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab0LODjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:39:54 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:58813 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587Ab0LODjx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:39:53 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=CCVe0ST0UiwMrfy8RsP-xfS9gCxUewv1q5Vu=@mail.gmail.com>
References: <1292374443-4055-1-git-send-email-fernando.lugo@ti.com>
	<AANLkTi=CCVe0ST0UiwMrfy8RsP-xfS9gCxUewv1q5Vu=@mail.gmail.com>
Date: Tue, 14 Dec 2010 21:39:50 -0600
Message-ID: <AANLkTinm5=8hVtDbBX-r+17CL-iMkEjHitBs=EdDhX0d@mail.gmail.com>
Subject: Re: [PATCHv7 0/4] omap: iovmm - fixes for iovmm module
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: "Kanigeri, Hari" <h-kanigeri2@ti.com>
Cc: Hiroshi.DOYU@nokia.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 7:54 PM, Kanigeri, Hari <h-kanigeri2@ti.com> wrote:
> Fernando,
>
> For omap patches, follow the convention
>
> OMAP: iommu: <subject>
> OMAP: iovmm: <subject>
>
> Ref: http://www.spinics.net/lists/linux-omap/msg39956.html

Ok, I will take in account that for next paches.

Thanks,
Fernando.

>
>
> On Tue, Dec 14, 2010 at 6:53 PM, Fernando Guzman Lugo
> <fernando.lugo@ti.com> wrote:
>> Misc fixes found while working with iovmm module. They are
>> needed in order to tidspbridge can work properly along with
>> iovmm module.
>>
>> Version 7:
>> * Change 4/4 patch base on Felipe Contreras comments about
>>  having start/end in platform data and struct iommu.
>>
>> Version 6:
>> * Rebase on Russell King branch.
>>  - for details see:
>>  http://marc.info/?l=linux-omap&m=129228495723001&w=2
>>
>> Version 5:
>> * Changes in "iommu: create new api to set valid da range"
>>  - Change range variables to platform data structure.
>>
>> Version 4:
>> * Changes in "iommu: create new api to set valid da range"
>>  - Validate range for fixed address.
>>  - Change way of change boundaries to avoid possible overflow
>>  instead of style :
>>     start + bytes >= end     which start + end can overflow
>>  use style:
>>     end - start < bytes
>>
>> Version 3:
>> * change patch 2 base on Felipe Contreras' comments,
>>  now it uses min_t and I deleted some blank lines.
>> * patch "create new api to set valid da range" is base on
>>  "iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF"
>>  patch and on Hiroshi's comments and now it is added to
>>  this set.
>>
>> Version 2:
>> * Removed "iovmm: fixes for iovmm module" that patch was already
>>  sent.
>> * Modified "iovmm: fix roundup for next area and end check for the
>>  last area" patch, base on Davin Cohen's comments and rename it
>>  to a proper name that describes what it is doing now.
>>
>>
>> Guzman Lugo, Fernando (4):
>>  omap: iovmm - no gap checking for fixed address
>>  omap: iovmm - add superpages support to fixed da address
>>  omap: iovmm - replace __iounmap with iounmap
>>  omap: iommu - create new api to set valid da range
>>
>>  arch/arm/mach-omap2/omap-iommu.c        |    8 +++
>>  arch/arm/plat-omap/include/plat/iommu.h |    5 ++
>>  arch/arm/plat-omap/iommu.c              |   24 +++++++++
>>  arch/arm/plat-omap/iovmm.c              |   81 +++++++++++++++++-------------
>>  4 files changed, 83 insertions(+), 35 deletions(-)
>>
>>
>
>
>
> --
> Thank you,
> Best regards,
> Hari Kanigeri
>
