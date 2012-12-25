Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab2LYFZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 00:25:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49674 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2LYFZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 00:25:03 -0500
Message-ID: <50D938AC.50001@wwwdotorg.org>
Date: Mon, 24 Dec 2012 22:25:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [PATCHv4 5/8] drm: tegra: Remove redundant host1x
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <1356089964-5265-6-git-send-email-tbergstrom@nvidia.com> <20121221143614.GA16167@avionic-0098.adnet.avionic-design.de> <50D55820.7030302@nvidia.com>
In-Reply-To: <50D55820.7030302@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 11:50 PM, Terje Bergström wrote:
> On 21.12.2012 16:36, Thierry Reding wrote:
>> On Fri, Dec 21, 2012 at 01:39:21PM +0200, Terje Bergstrom wrote:
>>> +static struct platform_driver tegra_drm_platform_driver = {
>>> +	.driver = {
>>> +		.name = "tegradrm",
>>
>> This should be "tegra-drm" to match the module name.
> 
> We've actually created two problems.
> 
> First is that the device name should match driver name which should
> match module name. But host1x doesn't know the module name of tegradrm.

There's no hard requirement for the device/driver name to match the
module name. It's good thing to do, but nothing will blow up if it don't
(modules can use MODULE_ALIAS() to declare which drivers they expose).

But, what's the problem with host1x knowing the driver name; the host1x
driver and tegradrm driver are both part of the same code-base, so this
seems trivial to achieve.

> Second problem is that host1x driver creates tegradrm device even if
> tegradrm isn't loaded to system.

That's fine. If there's no driver, the device simply won't be probe()d.
That's just like a device node existing in device tree, but the driver
for it not being enabled in the kernel, or the relevant module not being
inserted.

> These mean that the device has to be created in tegra-drm module to have

I definitely disagree here.
