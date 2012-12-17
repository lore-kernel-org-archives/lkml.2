Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2LQWOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:14:10 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:32975 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2LQWOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:14:06 -0500
Message-ID: <50CF992A.8080008@wwwdotorg.org>
Date: Mon, 17 Dec 2012 15:14:02 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: tegra: Set SCU base address dynamically from
 DT
References: <1355725087-11363-1-git-send-email-hdoyu@nvidia.com> <1355725087-11363-4-git-send-email-hdoyu@nvidia.com> <50CF258E.2080207@gmail.com>
In-Reply-To: <50CF258E.2080207@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 07:00 AM, Rob Herring wrote:
> On 12/17/2012 12:18 AM, Hiroshi Doyu wrote:
>> Set Snoop Control Unit(SCU) register base address dynamically from DT.

>> diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c

>>  static void __init tegra_smp_init_cpus(void)
>>  {
>> -	unsigned int i, ncores = scu_get_core_count(scu_base);
>> +	struct device_node *np;
>> +	unsigned int i, ncores = 1;
>> +
>> +	np = of_find_matching_node(NULL, cortex_a9_scu_match);
>> +	if (!np)
>> +		return;
>> +	scu_base = of_iomap(np, 0);
> 
> Did you actually test this? Unless something changed, ioremap does not
> work this early. The only reason to have it mapped this early is to get
> the core count, but that doesn't work on A15 or A7. So we really need to
> get core count/mask in a standard way. At least some work to get core
> count from DT went into 3.8.

Does it work if the machine's .map_io() function has set up a static
mapping that includes the specified region? I believe that is the case
on Tegra. What is the alternative if the registers can't be mapped;
should the code count the number of child nodes in /cpus?
