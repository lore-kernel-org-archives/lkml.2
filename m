Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab2GFOh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:37:28 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9290 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab2GFOhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:37:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 06 Jul 2012 07:37:17 -0700
Message-ID: <4FF6F7CF.9000405@nvidia.com>
Date: Fri, 6 Jul 2012 20:05:59 +0530
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
Subject: Re: [PATCH v3 0/6] Port Tegra to generic clk framework
References: <1341482120-3317-1-git-send-email-pgaikwad@nvidia.com> <4FF5E1C3.6070309@wwwdotorg.org>
In-Reply-To: <4FF5E1C3.6070309@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2012 12:19 AM, Stephen Warren wrote:
> On 07/05/2012 03:55 AM, Prashant Gaikwad wrote:
>> This patch set ports Tegra clock code to generic clock framework.
<snip>
> (The one slight difference between the 2 branches I tested is that AC100
> and Trimslice booted using DT passed in next-20120705 but failed only in
> Tegra's for-next. Otherwise, all results were identical)
>
> I'll try to investigate what the issues are since I imagine you don't
> have access to these boards. But, I probably won't be able to fix this
> until I return from vacation.

Stephen,

Can you please try removing "late_initcall(clk_disable_unused);" from 
drivers/clk/clk.c?
It will keep unused clocks enabled. If it works then there should not be 
any regression in this patch series but need to enable some board 
specific clock.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

