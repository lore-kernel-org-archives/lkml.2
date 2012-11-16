Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2KPQqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:46:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60884 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2KPQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:46:18 -0500
Message-ID: <50A66DD7.3030805@wwwdotorg.org>
Date: Fri, 16 Nov 2012 09:46:15 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: linux-tegra@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dt: tegra: cardhu: Add drm components
References: <1353042045-3182-1-git-send-email-markz@nvidia.com>
In-Reply-To: <1353042045-3182-1-git-send-email-markz@nvidia.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 10:00 PM, Mark Zhang wrote:
> This patch adds the rgb and hdmi nodes which are necessary for
> tegra drm driver.

> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi

> +	host1x {
> +		dc@54200000 {
> +			rgb {
> +				status = "okay";
> +				nvidia,ddc-i2c-bus = <&rgbddc>;
> +			};
> +		};
> +
> +		hdmi {
> +			status = "okay";
...
> +		};
> +	};

This patch enables both LCD (which will always get enabled, since
there's no way to unplug it) and HDMI (which may optionally get enabled,
depending on whether an HDMI device is plugged in). tegradrm currently
has issues when two outputs are enabled at once (and I just validated
this is still true with all the latest patches). As such, please can you
repost with only the internal LCD enabled. We can enable the LCD port
later once the tegradrm issues are fixed. Thanks.

With no HDMI plugged in, I tested Cardhu's LCD and it works fine.
