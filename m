Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2GEQDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:03:25 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10898 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab2GEQDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:03:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 05 Jul 2012 09:03:13 -0700
Message-ID: <4FF5BAB2.40007@nvidia.com>
Date: Thu, 5 Jul 2012 21:32:58 +0530
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
References: <1341313761-22118-1-git-send-email-pgaikwad@nvidia.com> <4FF31DFC.8030708@wwwdotorg.org> <4FF3D6BD.1000509@nvidia.com> <4FF5B378.6030305@wwwdotorg.org>
In-Reply-To: <4FF5B378.6030305@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2012 09:02 PM, Stephen Warren wrote:
> On 07/03/2012 11:38 PM, Prashant Gaikwad wrote:
>> On Tuesday 03 July 2012 09:59 PM, Stephen Warren wrote:
>>> On 07/03/2012 05:09 AM, Prashant Gaikwad wrote:
>>>> This patch set ports Tegra clock code to generic clock framework.
>>>>
>>>> Depends on
>>>> [PATCH v3 0/9] Add clk_prepare/clk_unprepare series
>>>> [PATCH] ARM: tegra: Remove second instance of uart clk
>>>> [PATCH] dma: tegra: add clk_prepare/clk_unprepare
>>>> [PATCH] ARM: tegra: dma: rename driver name for clock to "tegra-apbdma"
>>>>
>>>> Tested on Ventana and Cardhu
>>>>
>>>> v2:
>>>>    - Rebased on Tegra's for-3.6/common-clk
>>> OK, this applies to for-3.6/common-clk without issue now. However, there
>>> are still runtime problems:
>>>
>>> On Tegra20(Ventana), running Tegra's for-next branch with these patches
>>> merged in, if I play audio, the sound is much too low a pitch; the I2S
>>> clock must be being set too low. Also, if I play the same file twice,
>>> once encoded as 48KHz once encoded as 44.1KHz, the pitch is different.
>>>
>>> On Tegra20(Ventana), running next-20120703 plus a few local patches for
>>> regulators plus these common clock patches, then I see the same
>>> segfaults during boot that I mentioned before. It seems something in
>>> linux-next not in Tegra's for-next branch is breaking the common clock
>>> code for us.
>> Does these local patches include any changes in clock init table? Is it
>> possible to share the changes?
> My local dev branch is usually available at:
> git://nv-tegra.nvidia.com/user/swarren/linux-2.6 linux-next_common
>
> The local patches are mostly regulator support work-in-progress at the
> moment, so nothing to do with clocks, except one minor warning fix.
>
> I see you've posted v3; I assume that means you've found/fixed the
> issues - I'll go test.
I have fixed audio issue in v3. Another issue related to Tegra20 boot 
depends on the fix posted by Rajendra.
I have mentioned the dependency on the fix in v3.
