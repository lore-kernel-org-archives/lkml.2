Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2LTVem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:34:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15894 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab2LTVeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:34:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 20 Dec 2012 13:34:29 -0800
Message-ID: <50D38462.3060302@nvidia.com>
Date: Thu, 20 Dec 2012 23:34:26 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50D2D792.1050401@nvidia.com> <50D34775.5010606@wwwdotorg.org> <50D34F00.4080308@nvidia.com> <50D3511F.2090308@wwwdotorg.org> <50D35287.3040509@nvidia.com> <20121220203059.GA12977@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121220203059.GA12977@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.12.2012 22:30, Thierry Reding wrote:
> The problem with your proposed solution is that, even any of Stephen's
> valid objections aside, it won't work. Once the tegra-drm module is
> unloaded, the driver's data will be left in the current state and the
> link to the dummy device will be lost.

The dummy device is created by tegradrm's module init, because it's used
only by tegradrm. When tegradrm is unloaded, all the tegradrm devices
and drivers are unloaded and freed, including the dummy one.

> I don't think waiting for things to fail is the right option here. If we
> can make out this problem now, then now is the time to fix it. No
> excuses.

Of course not. If we know of something that fails now, let's not do that.

> And quite frankly given how all the various host1x components are
> interlinked I think having a single function that gets the DRM dummy
> device for DRM-related clients isn't that bad.

I like clear responsibilities. tegradrm is responsible for the DRM
interface, and host1x driver is responsible for host1x. tegradrm owns
its data, and can pass its pointers to the functions that need it.

But fine, I still don't like it, but I'll add host1x_set_tegradrm() and
host1x_get_tegradrm(), which act as setter and getter for tegradrm's
global data. I still think it's a solution to a problem we don't have,
but we've wasted an order of magnitude more time debating it than it
takes to implement.

Terje
