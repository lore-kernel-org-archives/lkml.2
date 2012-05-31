Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2EaD34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 23:29:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6557 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab2EaD3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 23:29:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6727"; a="193908087"
Message-ID: <4FC6E5B2.2010700@codeaurora.org>
Date: Wed, 30 May 2012 20:29:54 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] clk: add extension API
References: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com> <4FC5DFCF.1020606@codeaurora.org> <20120530194059.GA13243@gmail.com>
In-Reply-To: <20120530194059.GA13243@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 12:40 PM, Mike Turquette wrote:
> On 20120530-01:52, Stephen Boyd wrote:
>> On 5/29/2012 2:58 AM, Peter De Schrijver wrote:
>>> Add an extension API for clocks. This allows clocktypes to provide extensions
>>> for features which are uncommon and cannot be easily mapped onto normal clock
>>> framework concecpts. eg: resetting blocks, configuring clock phase etc.
>>
>> This seems rather generic. Why not add more specific APIs/concepts like
>> clk_reset(), clk_set_phase(), etc.? If they don't map, maybe we should
>> make them map.
>>
>
> I also wonder if exposing some of these knobs should be done in the
> basic clock types.  Meaning that instead of having additional calls in
> the clk.h API those calls could be exposed by the basic clock types that
> map to the actions.
>
> The question that needs to be answered is this: do generic drivers need
> access to these additional functions (clk.h) or just the platform code
> which implements some of the clock logic (basic clock types&
> platform-speciic clock types).

One of the main reason for the common clock framework is so that each 
platform doesn't have it's own extension and have mostly similar code 
repeat all over the place. So, having clock APIs outside of clk.h 
doesn't make sense when we look at the direction we want the code base 
to proceed in.

-Saravana


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
