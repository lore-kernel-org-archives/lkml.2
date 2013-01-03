Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3ACFzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 00:55:53 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:61210 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACFzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 00:55:51 -0500
Message-ID: <50E51D5F.6090009@gmail.com>
Date: Thu, 03 Jan 2013 13:55:43 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <50DD6311.9000002@gmail.com> <50E40106.4020406@nvidia.com> <50E4FBAF.30700@gmail.com> <50E51C08.1020603@nvidia.com>
In-Reply-To: <50E51C08.1020603@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 01:50 PM, Terje Bergström wrote:
> On 03.01.2013 05:31, Mark Zhang wrote:
>> Sorry I didn't get it. Yes, in current design, you can pin all mem
>> handles in one time but I haven't found anything related with "locking
>> only once per submit".
>>
>> My idea is:
>> - remove "job->addr_phys"
>> - assign "job->reloc_addr_phys" & "job->gather_addr_phys" separately
>> - In "pin_job_mem", just call "host1x_memmgr_pin_array_ids" twice to
>> fill the "reloc_addr_phy" & "gather_addr_phys".
>>
>> Anything I misunderstood?
> 
> The current design uses CMA, which makes pinning basically a no-op. When
> we have IOMMU support, pinning requires calling into IOMMU. Updating
> SMMU tables requires locking, and probably maintenance before SMMU code
> also requires its own locked data tables. For example, preventing
> duplicate pinning might require a global table of handles.
> 
> Putting all of the handles in one table allows doing duplicate detection
> across cmdbuf and reloc tables. This allows pinning each buffer exactly
> once, which reduces number of calls to IOMMU.
> 

Thanks Terje. Yes, I understand IOMMU will bring in more operations. But
I'm not convinced that separating 2 arrays have lots of overheads than
putting them into one array.

But it doesn't matter, after the IOMMU support version released, I can
read this part of codes again. Let's talk about this at that time.

>> "host1x_cma_pin_array_ids" doesn't return negative value right now, so
>> maybe you need to take a look at it.
> 
> True, and also a consequence of using CMA: pinning can never fail. With
> IOMMU, pinning can fail.

Got it. Agree.

> 
> Terje
> 
