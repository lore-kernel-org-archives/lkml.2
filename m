Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2GDFiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:38:24 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17470 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2GDFiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:38:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 03 Jul 2012 22:38:13 -0700
Message-ID: <4FF3D6BD.1000509@nvidia.com>
Date: Wed, 4 Jul 2012 11:08:05 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH v2 0/6] Port Tegra to generic clk framework
References: <1341313761-22118-1-git-send-email-pgaikwad@nvidia.com> <4FF31DFC.8030708@wwwdotorg.org>
In-Reply-To: <4FF31DFC.8030708@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2012 09:59 PM, Stephen Warren wrote:
> On 07/03/2012 05:09 AM, Prashant Gaikwad wrote:
>> This patch set ports Tegra clock code to generic clock framework.
>>
>> Depends on
>> [PATCH v3 0/9] Add clk_prepare/clk_unprepare series
>> [PATCH] ARM: tegra: Remove second instance of uart clk
>> [PATCH] dma: tegra: add clk_prepare/clk_unprepare
>> [PATCH] ARM: tegra: dma: rename driver name for clock to "tegra-apbdma"
>>
>> Tested on Ventana and Cardhu
>>
>> v2:
>>   - Rebased on Tegra's for-3.6/common-clk
> OK, this applies to for-3.6/common-clk without issue now. However, there
> are still runtime problems:
>
> On Tegra20(Ventana), running Tegra's for-next branch with these patches
> merged in, if I play audio, the sound is much too low a pitch; the I2S
> clock must be being set too low. Also, if I play the same file twice,
> once encoded as 48KHz once encoded as 44.1KHz, the pitch is different.
>
> On Tegra20(Ventana), running next-20120703 plus a few local patches for
> regulators plus these common clock patches, then I see the same
> segfaults during boot that I mentioned before. It seems something in
> linux-next not in Tegra's for-next branch is breaking the common clock
> code for us.

Does these local patches include any changes in clock init table? Is it 
possible to share the changes?

> Neither problem is seen on Cardhu with the same kernels.
>
> Can you please investigate and fix these issues? Thanks.

