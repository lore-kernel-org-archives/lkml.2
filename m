Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2LTW3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:29:03 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53196 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2LTW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:28:54 -0500
Message-ID: <50D39122.3060401@wwwdotorg.org>
Date: Thu, 20 Dec 2012 15:28:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50D2D792.1050401@nvidia.com> <50D34775.5010606@wwwdotorg.org> <50D34F00.4080308@nvidia.com> <50D3511F.2090308@wwwdotorg.org> <50D35287.3040509@nvidia.com> <20121220203059.GA12977@avionic-0098.adnet.avionic-design.de> <50D38462.3060302@nvidia.com>
In-Reply-To: <50D38462.3060302@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 02:34 PM, Terje Bergström wrote:
> On 20.12.2012 22:30, Thierry Reding wrote:
>> The problem with your proposed solution is that, even any of Stephen's
>> valid objections aside, it won't work. Once the tegra-drm module is
>> unloaded, the driver's data will be left in the current state and the
>> link to the dummy device will be lost.
> 
> The dummy device is created by tegradrm's module init, because it's used

No, the tegradrm driver object might be registered by tegradrm's module
init, but the dummy tegradrm platform device would need to be
created/registered by host1x's probe. Otherwise, the device would get
created even if there was no host1x/... in the system (disabled for some
reason, multi-SoC kernel, ...)
