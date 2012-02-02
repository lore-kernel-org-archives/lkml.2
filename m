Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab2BBXgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:36:52 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46515 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab2BBXgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:36:50 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6608"; a="160133576"
Message-ID: <4F2B1E11.1040000@codeaurora.org>
Date: Thu, 02 Feb 2012 15:36:49 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
References: <1328210686-15909-1-git-send-email-sboyd@codeaurora.org> <20120202204411.GB14129@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1202021632400.2759@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1202021632400.2759@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/12 13:38, Nicolas Pitre wrote:
> On Thu, 2 Feb 2012, Russell King - ARM Linux wrote
>> On Thu, Feb 02, 2012 at 11:24:46AM -0800, Stephen Boyd wrote:
>>> Should we move get_thread_info into assembler.h? It seems odd
>>> to include entry-header.S but I saw that vfp was doing the same.
>> Probably yes, and probably also have preempt_disable and preempt_enable
>> assembler macros.  That's going to get rather icky if we have to
>> explicitly call the scheduler though (to solve (1)).
> What about a pair of helpers written in C instead?
>
> v7_flush_dcache_all() could be renamed, and a wrapper function called 
> v7_flush_dcache_all() would call the preemption disable helper, call the 
> former v7_flush_dcache_all code, then call the preemption enable helper.
>
> Then __v7_setup() could still call the core cache flush code without 
> issues.

I tried to put the preemption disable/enable right around the place
where it was needed. With this approach we would disable preemption
during the entire cache flush. I'm not sure if we want to make this
function worse for performance, do we? It certainly sounds easier than
writing all the preempt macros in assembly though.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

