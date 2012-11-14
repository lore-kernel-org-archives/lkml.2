Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423089Ab2KNQpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:45:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9419 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422671Ab2KNQpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:45:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 14 Nov 2012 08:45:27 -0800
Message-ID: <50A3CAA3.2060908@nvidia.com>
Date: Wed, 14 Nov 2012 18:45:23 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de> <50A357D3.9080002@nvidia.com> <20121114084931.GA31837@avionic-0098.mockup.avionic-design.de> <50A3712E.7000104@nvidia.com> <20121114105406.GA31455@avionic-0098.mockup.avionic-design.de> <50A3C485.7080704@wwwdotorg.org>
In-Reply-To: <50A3C485.7080704@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.11.2012 18:19, Stephen Warren wrote:
> I'd rather initialize it explicitly. If setting it to 216MHz works
> fine as Terje indicated, we may as well just do that.

I'd prefer explicit setting, too.

> I suspect the issue with the original code:
> 
>> { "host1x",     "pll_c",        144000000,      false },
> 
> ... is that perhaps the requested 144MHz can't be generated from
> pll_c's 600MHz rate, since there's a simple U7.1 divider there (you
> could get 120, 133.333, 150), so the clock ends up being programmed to
> some incorrect value. In the pll_p/216MHz case, pll_p is programmed to
> generate 216MHz anyway, so requesting the same rate for host1x yields
> a divider of 1 exactly which works fine.

I could try the values you proposed tomorrow when I get back to office.
I believe we've always kept host1x under non-fractional dividers, so I'd
like to try 150MHz on Ventana and 150MHz and 300MHz on Cardhu.

600MHz sounds pretty high for PLLC on Tegra20. For Tegra30 it would be
understandable. In internal kernel I believe we have lower rate for
Tegra20 PLLC. Do we have anything running from PLLC in Tegra20 upstream
kernel?

Terje
