Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab2HTRtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:49:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41908 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2HTRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:49:15 -0400
Message-ID: <50327897.5030601@wwwdotorg.org>
Date: Mon, 20 Aug 2012 11:49:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] ARM: dt: tegra: harmony: add regulators
References: <1345186799-18229-1-git-send-email-ldewangan@nvidia.com> <502E9B09.3080800@wwwdotorg.org> <502EA1AC.4090205@wwwdotorg.org> <50327242.80103@nvidia.com>
In-Reply-To: <50327242.80103@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 11:22 AM, Laxman Dewangan wrote:
> On Saturday 18 August 2012 01:25 AM, Stephen Warren wrote:
>> On 08/17/2012 01:27 PM, Stephen Warren wrote:
>>> On 08/17/2012 12:59 AM, Laxman Dewangan wrote:
>>>> Harmony uses a TPS6586x regulator. Instantiate this, and hook up a
>>>> couple of fixed GPIO-controlled regulators too.
>>>>
>>>> Based on Ventana regulator patch by Stephen Warren<swarren@nvidia.com>
>>>> and converted to Harmony.
>>> Thanks, applied to Tegra's for-3.7/dt branch.
>> Oh hang on, this adds regulators to DT, but doesn't do anything to
>> remove the board-file registration of Harmony's regulators from
>> board-dt-tegra20.c, which end up conflicting, and preventing the PCIe
>> driver from being registered.
>>
>> So, this patch really wants to remove the legacy code to, but doing so
>> will be problematic; to avoid runtime git bisect failures, we'd need to
>> merge the regulator tree in first, or wait until next kernel release or
>> something... Thoughts?
> 
> Why not just remove the regulator registration from board files along
> with the dt entry (in one patch). That will resolve the issue of bisect.

The problem there is that will prevent any regulators from being
registered at all, until the patch is merged with the regulator tree.
That will also prevent PCIe working on Harmony. Those both work right
now, so that's a bisection breakage.

I suppose the solution here is to merge the regulator tree into the
Tegra branch before the Harmony regulator patch. Mark, can we do that?
