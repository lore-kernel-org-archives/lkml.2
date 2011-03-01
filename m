Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1CAEVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 23:21:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52031 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1CAEVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 23:21:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6271"; a="77247092"
Message-ID: <4D6C742C.40507@codeaurora.org>
Date: Mon, 28 Feb 2011 20:21:00 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/4] msm: scm: Get cacheline size from CTR
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org> <1298573085-23217-5-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.00.1102241959290.2701@localhost6.localdomain6> <4D66B505.6010702@codeaurora.org> <alpine.LFD.2.00.1102242056010.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102242056010.2701@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 11:56 AM, Thomas Gleixner wrote:
> On Thu, 24 Feb 2011, Stephen Boyd wrote:
>
>>
>> I definitely don't want to do it for every loop. I'm fine with getting
>> it every scm_call() invocation though.
>>
>> For now, I'll pull the end and cacheline_size variables out of the
>> do-while loop.
>
> Why not do it correct right away and retrieve it in an __init
> function?

That would require an early_initcall, so hopefully that is fine.

I wonder why the generic arm v7 cache operations don't do the same thing
and store the dcache line size somewhere. Every dma operation is
essentially calling dcache_line_size(). Perhaps some generic arm code
should be determining the dcache line size really early on and storing
it in the proc_info_list? Then both the dma code and scm code could
query the processor for the dcache line size with something like
cpu_dcache_line_size?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

