Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab2KNP3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:29:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8588 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736Ab2KNP3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:29:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 14 Nov 2012 07:29:37 -0800
Message-ID: <50A3B8DD.7010607@nvidia.com>
Date: Wed, 14 Nov 2012 17:29:33 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: tegra: Add Tegra20 host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de> <1352467202-27903-2-git-send-email-thierry.reding@avionic-design.de> <50A357D3.9080002@nvidia.com> <20121114150125.GA11050@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121114150125.GA11050@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.11.2012 17:01, Thierry Reding wrote:
> Funny. I just tested with this line removed and I also get the freeze.
> With the line I don't get the freeze. Does the freeze only occur with
> additional patches on top? If so I think we should keep the line in for
> now because it is what most people have tested against and which has
> proven to work. We can fix any remaining issues with host1x specific
> things when actual patches emerge.

I was running with 2D acceleration support added on top of your
gitorious tree. It was the nvhost driver, which probes host1x, and
initializes it. In middle of initialization (writing zeros to sync point
registers), host1x stops responding.

I agree, if removing the line causes regression, keep it and let's debug
this issue later.

It might be that we have a difference in bootloader. Does your
bootloader enable display? U-Boot and fastboot do, and it might be that
has an effect. They would need to initialize host1x clocks, and it might
be that kernel initialization somehow clashes with bootloader's.

Best regards,
Terje
