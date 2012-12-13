Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2LMPdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:33:54 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9925 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab2LMPdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:33:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 13 Dec 2012 07:32:01 -0800
Message-ID: <50C9F553.5030401@nvidia.com>
Date: Thu, 13 Dec 2012 17:33:39 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 0/7] Support for Tegra 2D hardware
References: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com> <1355410991.11327.12.camel@selen>
In-Reply-To: <1355410991.11327.12.camel@selen>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.12.2012 17:03, Lucas Stach wrote:
> You are still doing the allocation the IMHO wrong way around. I thought
> we agreed to do all the allocations in host1x, which obviously means not
> using the cma_gem_helpers anymore, but introducing a new native host1x
> object to back GEM/V4L/whatever objects. IMHO the current approach is a
> clear layering violation and makes proper IOMMU support a lot harder. It
> would also allow to get rid of all the indirections and ifdefs in host1x
> memmgr, as host1x would only have to deal with it's native objects.
> 
> All the complexity of converting host1x to GEM objects should be located
> in tegradrm and not be scattered between different modules.
> 
> Did you leave this out on purpose in this version of the patchset?

Forgot to mention that, as IOMMU and consequently the "proper"
allocation support was planned as a follow-up. I wanted to keep the
scope of this set as small as possible.

The plan we agreed on still holds.

Terje

>>  * tegradrm has a global variable. Plan was to hide that behind a
>>    virtual device, and use that as DRM root device. That plan went
>>    bad once the FB CMA helper used the device for trying to allocate
>>    memory.
> See above, we should get rid of the helpers and do all allocations
> within host1x.

I noticed that IOMMU and not using the CMA FB helper is now exynos
managed to do this.

Terje
