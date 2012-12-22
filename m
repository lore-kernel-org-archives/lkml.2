Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab2LVGun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 01:50:43 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1188 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2LVGul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 01:50:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 21 Dec 2012 22:50:12 -0800
Message-ID: <50D55820.7030302@nvidia.com>
Date: Sat, 22 Dec 2012 08:50:08 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "airlied@linux.ie" <airlied@linux.ie>, "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [PATCHv4 5/8] drm: tegra: Remove redundant host1x
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <1356089964-5265-6-git-send-email-tbergstrom@nvidia.com> <20121221143614.GA16167@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121221143614.GA16167@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.12.2012 16:36, Thierry Reding wrote:
> On Fri, Dec 21, 2012 at 01:39:21PM +0200, Terje Bergstrom wrote:
>> +static struct platform_driver tegra_drm_platform_driver = {
>> +	.driver = {
>> +		.name = "tegradrm",
> 
> This should be "tegra-drm" to match the module name.

We've actually created two problems.

First is that the device name should match driver name which should
match module name. But host1x doesn't know the module name of tegradrm.

Second problem is that host1x driver creates tegradrm device even if
tegradrm isn't loaded to system.

These mean that the device has to be created in tegra-drm module to have
access to the module name. So instead of just getter, we need a getter
and a setter.

Terje
