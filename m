Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2HTRlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:41:10 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1278 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2HTRlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:41:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 20 Aug 2012 10:40:56 -0700
Message-ID: <50327242.80103@nvidia.com>
Date: Mon, 20 Aug 2012 22:52:10 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] ARM: dt: tegra: harmony: add regulators
References: <1345186799-18229-1-git-send-email-ldewangan@nvidia.com> <502E9B09.3080800@wwwdotorg.org> <502EA1AC.4090205@wwwdotorg.org>
In-Reply-To: <502EA1AC.4090205@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 August 2012 01:25 AM, Stephen Warren wrote:
> On 08/17/2012 01:27 PM, Stephen Warren wrote:
>> On 08/17/2012 12:59 AM, Laxman Dewangan wrote:
>>> Harmony uses a TPS6586x regulator. Instantiate this, and hook up a
>>> couple of fixed GPIO-controlled regulators too.
>>>
>>> Based on Ventana regulator patch by Stephen Warren<swarren@nvidia.com>
>>> and converted to Harmony.
>> Thanks, applied to Tegra's for-3.7/dt branch.
> Oh hang on, this adds regulators to DT, but doesn't do anything to
> remove the board-file registration of Harmony's regulators from
> board-dt-tegra20.c, which end up conflicting, and preventing the PCIe
> driver from being registered.
>
> So, this patch really wants to remove the legacy code to, but doing so
> will be problematic; to avoid runtime git bisect failures, we'd need to
> merge the regulator tree in first, or wait until next kernel release or
> something... Thoughts?

Why not just remove the regulator registration from board files along 
with the dt entry (in one patch). That will resolve the issue of bisect.

