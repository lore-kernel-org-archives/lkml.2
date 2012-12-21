Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2LUI6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:58:41 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19860 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2LUI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:58:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 21 Dec 2012 00:58:26 -0800
Message-ID: <50D42486.7080901@nvidia.com>
Date: Fri, 21 Dec 2012 10:57:42 +0200
From: Arto Merilainen <amerilainen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Terje Bergstrom <tbergstrom@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de> <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50D2D792.1050401@nvidia.com> <50D34775.5010606@wwwdotorg.org>
In-Reply-To: <50D34775.5010606@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:14 PM, Stephen Warren wrote:
>
> What's wrong with just having each device ask the host1x (its parent)
> for a pointer to the (dummy) tegradrm device. That seems extremely
>

We are talking about creating a dummy device because:
- we need to give something for drm_platform_init(),
- drm related data should be stored somewhere,
- some data must be passed to all driver probe() functions. This is not 
hw-related data, but just some lists that are used to ensure that all 
drivers have been initialised before calling drm_platform_init().

All these issues are purely tegra-drm related and solving them elsewhere 
(in host1x) would be just wrong! host1x would not even use the dummy 
device for anything so creating it there seems bizarre.

- Arto
