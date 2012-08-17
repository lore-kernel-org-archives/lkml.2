Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2HQPSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:18:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60583 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab2HQPR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:17:59 -0400
Message-ID: <502E60A3.1020405@wwwdotorg.org>
Date: Fri, 17 Aug 2012 09:17:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
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
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com> <1345126397-28864-2-git-send-email-ldewangan@nvidia.com> <502D33B6.7070103@wwwdotorg.org> <502DE6FE.8040200@nvidia.com>
In-Reply-To: <502DE6FE.8040200@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 12:38 AM, Laxman Dewangan wrote:
> On Thursday 16 August 2012 11:23 PM, Stephen Warren wrote:
>> On 08/16/2012 08:13 AM, Laxman Dewangan wrote:
>>> Enable config for dmaengine based Tegra APB DMA driver and
>>> disable the legacy APB DMA driver (SYSTEM_DMA).
>> Laxman, if I apply this series to next-20120816 (plus a few patches in
>> my local work branch plus the CPU hotplug patches from Joseph, although
>> I suspect none of that matters), then audio playback on Tegra20 is
>> broken; the pitch is far too high. Audio playback on Tegra30 works as
>> expected.
>
> I run the test again on ventana and did not see any issue.
> I play one song and saw similar behavior with/without this series.

OK, I'll test some other boards. I tested Whistler, although all the
clocking logic is identical between all Tegra20 boards.

> With this series:
> --------------------
> 
> ubuntu@tegra-ubuntu:/home$ aplay "1-04 Hungry Like The Wolf.wav"
> Playing WAVE '1-04 Hungry Like The Wolf.wav' : Signed 16 bit Little
> Endian, Rate
>  44100 Hz, Stereo
> underrun!!! (at least 5039.388 ms long)

Why are you getting all these underruns? I almost never see this, except
when something else is hammering the SD card containing the .wav file.
If I saw those, I'd count it as a test failure.
