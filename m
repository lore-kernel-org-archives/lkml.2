Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2K1QYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:24:33 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56172 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2K1QYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:24:32 -0500
Message-ID: <50B63AB5.4090801@wwwdotorg.org>
Date: Wed, 28 Nov 2012 09:24:21 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
CC: Lucas Stach <dev@lynxeye.de>, Dave Airlie <airlied@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>   <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>   <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>   <50B46336.8030605@nvidia.com>   <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>   <50B476E1.4070403@nvidia.com>   <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>   <50B47DA8.60609@nvidia.com>	<1354011776.1479.31.camel@tellur>   <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>   <50B4A483.8030305@nvidia.com>   <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>   <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur>  <50B61845.6060102@nvidia.com> <1354111565.1479.73.camel@tellur> <50B6237B.8010808@nvidia.com>
In-Reply-To: <50B6237B.8010808@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 07:45 AM, Terje Bergström wrote:
> On 28.11.2012 16:06, Lucas Stach wrote:
>> Why do even need/use dma-buf for this use case? This is all one DRM
>> device, even if we separate host1x and gr2d as implementation modules.
> 
> I didn't want to implement dependency to drm gem objects in nvhost, but
> we have thought about doing that. dma-buf brings quite a lot of
> overhead, so implementing support for gem buffers would make the
> sequence a bit leaner.
> 
> nvhost already has infra to support multiple memory managers.
> 
>> So standard way of doing this is:
>> 1. create gem object for pushbuffer
>> 2. create fake mmap offset for gem obj
>> 3. map pushbuf using the fake offset on the drm device
>> 4. at submit time zap the mapping
>>
>> You need this logic anyway, as normally we don't rely on userspace to
>> sync gpu and cpu, but use the kernel to handle the concurrency issues.
> 
> Taking a step back - 2D streams are actually very short, in the order of
> <100 bytes. Just copying them to kernel space would actually be faster
> than doing MMU operations.

I'm not sure it's a good idea to have one buffer submission mechanism
for the 2D class and another for the 3D/... class, nor to bet that 2D
streams will always be short.
