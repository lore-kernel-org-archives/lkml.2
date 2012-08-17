Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885Ab2HQG4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 02:56:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9406 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831Ab2HQG4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 02:56:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 16 Aug 2012 23:56:39 -0700
Message-ID: <502DE6FE.8040200@nvidia.com>
Date: Fri, 17 Aug 2012 12:08:54 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "olof@lixom.net" <olof@lixom.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 1/5] ARM: tegra: config: enable dmaengine based APB DMA
 driver
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com> <1345126397-28864-2-git-send-email-ldewangan@nvidia.com> <502D33B6.7070103@wwwdotorg.org>
In-Reply-To: <502D33B6.7070103@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012 11:23 PM, Stephen Warren wrote:
> On 08/16/2012 08:13 AM, Laxman Dewangan wrote:
>> Enable config for dmaengine based Tegra APB DMA driver and
>> disable the legacy APB DMA driver (SYSTEM_DMA).
> Laxman, if I apply this series to next-20120816 (plus a few patches in
> my local work branch plus the CPU hotplug patches from Joseph, although
> I suspect none of that matters), then audio playback on Tegra20 is
> broken; the pitch is far too high. Audio playback on Tegra30 works as
> expected.
I run the test again on ventana and did not see any issue.
I play one song and saw similar behavior with/without this series.

With this series:
--------------------

ubuntu@tegra-ubuntu:/home$ aplay "1-04 Hungry Like The Wolf.wav"
Playing WAVE '1-04 Hungry Like The Wolf.wav' : Signed 16 bit Little 
Endian, Rate
  44100 Hz, Stereo
underrun!!! (at least 5039.388 ms long)
underrun!!! (at least 60.601 ms long)
underrun!!! (at least 3027.668 ms long)
underrun!!! (at least 2063.667 ms long)
underrun!!! (at least 1062.503 ms long)
underrun!!! (at least 5073.551 ms long)
underrun!!! (at least 6.461 ms long)
underrun!!! (at least 4075.519 ms long)
underrun!!! (at least 78.731 ms long)
underrun!!! (at least 4042.804 ms long)
underrun!!! (at least 28.395 ms long)
underrun!!! (at least 5076.706 ms long)
underrun!!! (at least 6043.105 ms long)
underrun!!! (at least 24.857 ms long)
underrun!!! (at least 5023.783 ms long)
ubuntu@tegra-ubuntu:/home$

And on tot:
--------------
ubuntu@tegra-ubuntu:/home$ aplay "1-04 Hungry Like The Wolf.wav"
Playing WAVE '1-04 Hungry Like The Wolf.wav' : Signed 16 bit Little 
Endian, Rate
  44100 Hz, Stereo
underrun!!! (at least 17098.259 ms long)
underrun!!! (at least 5042.101 ms long)
underrun!!! (at least 87.446 ms long)
underrun!!! (at least 4084.481 ms long)
underrun!!! (at least 4035.531 ms long)
underrun!!! (at least 1026.132 ms long)
underrun!!! (at least 3096.078 ms long)
underrun!!! (at least 1007.028 ms long)
underrun!!! (at least 1034.265 ms long)
underrun!!! (at least 2092.453 ms long)
underrun!!! (at least 1029.957 ms long)
underrun!!! (at least 3076.209 ms long)
underrun!!! (at least 52.042 ms long)
underrun!!! (at least 1001.812 ms long)
underrun!!! (at least 3083.294 ms long)
ubuntu@tegra-ubuntu:/home$
