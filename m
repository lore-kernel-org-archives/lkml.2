Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992677Ab2KOGxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:53:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1624 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab2KOGxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:53:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Nov 2012 22:52:59 -0800
Message-ID: <50A49211.4060303@nvidia.com>
Date: Thu, 15 Nov 2012 08:56:17 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de> <50A357D3.9080002@nvidia.com> <20121114084931.GA31837@avionic-0098.mockup.avionic-design.de> <50A3712E.7000104@nvidia.com> <20121114105406.GA31455@avionic-0098.mockup.avionic-design.de> <50A3C485.7080704@wwwdotorg.org> <20121114200415.GA10335@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121114200415.GA10335@avionic-0098.mockup.avionic-design.de>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.11.2012 22:04, Thierry Reding wrote:
> According to tegra20_clocks_data.c, the maximum clock frequency for
> host1x is 166 MHz, so 216 is probably not a good idea. 150 MHz sounds
> sensible, though.
> 
> I was going to send a new version of the patch set tonight, but I'll
> wait until I can test it tomorrow and once Terje has reported back that
> things work fine.

Hi,

I tried with 150MHz, 133.3MHz, 100MHz and as an act of desperation
300MHz. None of them worked. pll_p with 216MHz seems to be the only
option that works on my board.

But, as said, this seems to affect only the case where nvhost is
integrated, too, so your patch creates a working DRM and frame buffer,
so I'm fine with leaving it as it was in the original patch set.

Meanwhile, we need to figure out if we somehow misprogram PLLC or host1x
clock when it's attached to PLLC on Tegra20.

Terje
