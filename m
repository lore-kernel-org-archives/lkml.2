Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab2LATaI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 14:30:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6250 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2LATaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 14:30:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 01 Dec 2012 11:29:58 -0800
Message-ID: <50BA5AB2.8000604@nvidia.com>
Date: Sat, 1 Dec 2012 21:29:54 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>  <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>  <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>  <50B73710.2040102@nvidia.com>  <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>  <50B7AB93.5060207@wwwdotorg.org> <1354265429.1479.187.camel@tellur>  <50B9EDA9.2000500@nvidia.com>  <20121201151020.GC18209@avionic-0098.adnet.avionic-design.de>  <50BA3668.1010504@nvidia.com> <1354383291.1503.25.camel@tellur>
In-Reply-To: <1354383291.1503.25.camel@tellur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2012 19:34, Lucas Stach wrote:
> This would certainly make life easier, but personally I don't think it's
> the right thing to do. The separation of the Linux kernel into different
> subsystems was done for a reason and just because the specific hardware
> at hands happens to work a bit different is no valid reason to break
> with the standard rules of the kernel.
> 
> So I think there is no way around handling the different drivers that
> use host1x in different trees. For the time being there is _only_
> tegra-drm using host1x in the upstream kernel. We have to make sure to
> come up with some API which is reasonably stable, so we don't run into
> big problems later. That's why I'm really in favour to keep host1x and
> tegra-drm side by side in the current upstream, to make sure we can
> change the API without jumping through too much hoops.
> 
> Your downstream V4L would have to use host1x from the DRM directory, but
> really: is your downstream such a nice, clean codebase that you are not
> able to cope with the slight ugliness of this solution?

Ok, can do. I'll move the code base to drivers/gpu/drm/tegra/host1x. For
downstream, the host1x driver implements all user space APIs (no drm, no
v4l, etc) so the directory is of no consequence. If we immersed host1x
driver totally with tegra-drm, that'd be a problem, but if I can keep a
separation, that's fine.

> Please make sure to remove any unnecessary cruft from host1x in the
> process and don't try to make too big of a step at once. We only need
> one type of memory within host1x: native host1x objects, no need to plan
> for support of anything else. Also taking over ownership of the IOMMU
> address space might take some more work in the IOMMU API. We can leave
> this out completely for a start. Both Tegra 2 and 3 should be able to
> work with CMA backed objects just fine.

Ok, that simplifies the process. I'll just implement firewall and copy
the strema over to kernel space unconditionally.

Terje
