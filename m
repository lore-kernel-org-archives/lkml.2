Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab2LUG0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 01:26:49 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13662 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2LUG0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 01:26:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 20 Dec 2012 22:26:35 -0800
Message-ID: <50D40236.9080403@nvidia.com>
Date: Fri, 21 Dec 2012 08:31:18 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50D2D792.1050401@nvidia.com> <50D34775.5010606@wwwdotorg.org> <50D34F00.4080308@nvidia.com> <50D3511F.2090308@wwwdotorg.org> <50D35287.3040509@nvidia.com> <20121220203059.GA12977@avionic-0098.adnet.avionic-design.de> <50D38462.3060302@nvidia.com> <50D39122.3060401@wwwdotorg.org>
In-Reply-To: <50D39122.3060401@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.12.2012 00:28, Stephen Warren wrote:
> On 12/20/2012 02:34 PM, Terje Bergström wrote:
>> On 20.12.2012 22:30, Thierry Reding wrote:
>>> The problem with your proposed solution is that, even any of Stephen's
>>> valid objections aside, it won't work. Once the tegra-drm module is
>>> unloaded, the driver's data will be left in the current state and the
>>> link to the dummy device will be lost.
>>
>> The dummy device is created by tegradrm's module init, because it's used
> 
> No, the tegradrm driver object might be registered by tegradrm's module
> init, but the dummy tegradrm platform device would need to be
> created/registered by host1x's probe. Otherwise, the device would get
> created even if there was no host1x/... in the system (disabled for some
> reason, multi-SoC kernel, ...)

Oh. I was all the time thinking that dummy device needs to be created by
tegradrm, because it's only used by tegradrm.  But as we're mixing the
responsibilities, we might then just as well go all the way.

Terje
