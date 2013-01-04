Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3ADUZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 15:25:13 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56432 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3ADUZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 15:25:11 -0500
Message-ID: <50E73AA2.7090500@wwwdotorg.org>
Date: Fri, 04 Jan 2013 13:25:06 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de> <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50D2D792.1050401@nvidia.com> <50D34775.5010606@wwwdotorg.org> <50D42486.7080901@nvidia.com> <50D4D25B.7030506@wwwdotorg.org> <50E6AA69.4030001@nvidia.com>
In-Reply-To: <50E6AA69.4030001@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 03:09 AM, Terje Bergström wrote:
...
> I think we have now two ways to go forward with cons and pros:
>  1) Keep host1x and tegra-drm as separate driver
>    + Code almost done
>    - we need dummy device and dummy driver
>    - extra code and API when host1x creates dummy device and its passed
> to tegra-drm

Just to play devil's advocate:

I suspect that's only a few lines of code.

>    - tegra-drm device would need to be a child of host1x device. Having
> virtual and real devices as host1x children sounds weird.

And I doubt that would cause problems.

>  2) Merge host1x and tegra-drm into one module. drm is a subcomponent,
> and whatever other personalities we wish would also be subcomponents of
> host1x. host1x calls tegra-drm directly to handle preparation for drm
> initialization. As they're in the same module, circular dependency is ok.
>    + Simpler conceptually (no dummy device/driver)
>    + Less code
>    - Proposal doesn't yet exist

But that said, I agree this approach would be very reasonable; it seems
to me that host1x really is the main HW behind a DRM driver or a V4L2
driver or ... As such, it seems quite reasonable for a single struct
device to exist that represents host1x, and for the driver for that
device to register both a DRM and a V4L2 driver etc. The code could
physically be organized into separate modules, and under different
Kconfig options for configurability etc.

But either way, I'll let you (Thierry and Terje) work out which way to go.
