Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab2LTROi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 12:14:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53198 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LTROc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 12:14:32 -0500
Message-ID: <50D34775.5010606@wwwdotorg.org>
Date: Thu, 20 Dec 2012 10:14:29 -0700
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
References: <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de> <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50D2D792.1050401@nvidia.com>
In-Reply-To: <50D2D792.1050401@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 02:17 AM, Terje Bergström wrote:
> On 16.12.2012 14:16, Thierry Reding wrote:
>> Okay, so we're back on the topic of using globals. I need to assert
>> again that this is not an option. If we were to use globals, then we
>> could just as well leave out the dummy device and just do all of that in
>> the tegra-drm driver's initialization function.
> 
> I found a way of dropping the global in a straightforward way, and
> introduce dummy device for drm_platform_init().
> 
> I added dummy device and driver, and moved the tegradrm global
> (previously called struct host1x *host1x) allocation to happen in the
> probe. In addition, probe calls device tree node traversal to do the
> tegra_drm_add_client() calls. The dummy device is owner for this global.
> 
> I changed the device tree node traversal so that it goes actually
> through each host1x child, checks if it's supported by tegradrm, and if
> so, sets its drvdata to point to the tegradrm data.

I'm not sure that sounds right. drvdata is something that a driver
should manage itself.

What's wrong with just having each device ask the host1x (its parent)
for a pointer to the (dummy) tegradrm device. That seems extremely
simple, and doesn't require abusing existing stuff like drvdata for
non-standard purposes.
