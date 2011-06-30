Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1F3Qgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:36:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54343 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1F3Qgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:36:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6392"; a="101131872"
Message-ID: <4E0CA604.5080802@codeaurora.org>
Date: Thu, 30 Jun 2011 09:36:20 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-tegra@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] arm: platsmp: Allow secondary cpu hotplug with	maxcpus=1
References: <1309372300-28911-1-git-send-email-sboyd@codeaurora.org> <20110630131154.GJ23312@n2100.arm.linux.org.uk>
In-Reply-To: <20110630131154.GJ23312@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/2011 6:11 AM, Russell King - ARM Linux wrote:
> On Wed, Jun 29, 2011 at 11:31:39AM -0700, Stephen Boyd wrote:
>>  void __init platform_smp_prepare_cpus(unsigned int max_cpus)
>>  {
>> -	int i;
>> -
>>  	/*
>>  	 * Initialise the present map, which describes the set of CPUs
>>  	 * actually populated at the present time.
>>  	 */
>> -	for (i = 0; i < max_cpus; i++)
>> -		set_cpu_present(i, true);
>> +	init_cpu_present(&cpu_possible_map);
> Ok, if we're now doing this in every platform, it might as well go into
> arch/arm/kernel/smp.c - platforms can re-initialize the present map
> in this callback if they need to do something different.

That sounds better. V2 coming soon.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

