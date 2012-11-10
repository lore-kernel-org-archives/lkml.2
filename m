Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab2KJAKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:10:07 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:32928 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2KJAKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:10:01 -0500
Message-ID: <509D9B4F.6060003@wwwdotorg.org>
Date: Fri, 09 Nov 2012 17:09:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de> <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 06:59 AM, Thierry Reding wrote:
> This commit adds a KMS driver for the Tegra20 SoC. This includes basic
> support for host1x and the two display controllers found on the Tegra20
> SoC. Each display controller can drive a separate RGB/LVDS output.

I applied these two patches and the two arch/arm/mach-tegra patches you
posted, directly on top of next-20121109, and I see the following build
failure:

> drivers/gpu/drm/tegra/output.c: In function 'tegra_output_init':
> drivers/gpu/drm/tegra/output.c:166:9: error: 'struct tegra_output' has no member named 'display'
> drivers/gpu/drm/tegra/output.c:166:3: error: implicit declaration of function 'of_get_display'
> drivers/gpu/drm/tegra/output.c:167:20: error: 'struct tegra_output' has no member named 'display'
> drivers/gpu/drm/tegra/output.c:168:25: error: 'struct tegra_output' has no member named 'display'
> drivers/gpu/drm/tegra/output.c:179:13: error: 'struct tegra_output' has no member named 'display'
> drivers/gpu/drm/tegra/output.c:180:3: error: implicit declaration of function 'display_put'
> drivers/gpu/drm/tegra/output.c:180:21: error: 'struct tegra_output' has no member named 'display'
> drivers/gpu/drm/tegra/output.c:257:20: error: 'struct tegra_output' has no member named 'display'
> drivers/gpu/drm/tegra/output.c: In function 'tegra_output_exit':
> drivers/gpu/drm/tegra/output.c:272:20: error: 'struct tegra_output' has no member named 'display'

Does this depend on something not in linux-next?
