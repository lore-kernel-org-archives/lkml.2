Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2KPQnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:43:46 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55231 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2KPQnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:43:45 -0500
Message-ID: <50A66D3D.4040708@wwwdotorg.org>
Date: Fri, 16 Nov 2012 09:43:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: airlied@redhat.com, thierry.reding@avionic-design.de,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] drm: Add NVIDIA Tegra30 support
References: <1353041889-3114-1-git-send-email-markz@nvidia.com>
In-Reply-To: <1353041889-3114-1-git-send-email-markz@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 09:58 PM, Mark Zhang wrote:
> This patch is based on Thierry's drm patch for Tegra20:
> - [PATCH v2 0/6] Device tree updates for host1x support
> - [PATCH v3 0/2] NVIDIA Tegra DRM driver

> diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
> index 216cd0f..6e9f1b4 100644
> --- a/drivers/gpu/drm/tegra/dc.c
> +++ b/drivers/gpu/drm/tegra/dc.c
> @@ -819,6 +819,7 @@ static int tegra_dc_remove(struct platform_device *pdev)
>  
>  static struct of_device_id tegra_dc_of_match[] = {
>         { .compatible = "nvidia,tegra20-dc", },
> +	{ .compatible = "nvidia,tegra30-dc", },

The Tegra30 entries should come first in the table due to the order the
kernel (currently) matches compatible properties against theses tables.
The same comment applies for all 3 tables.

With the patch manually applied (due to the whitespace issues I
mentioned earlier), and this ordering issue fixed,

Tested-by: Stephen Warren <swarren@nvidia.com>

(On Cardhu, with no HDMI plugged in; see my next email for details).
