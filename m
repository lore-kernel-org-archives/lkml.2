Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab1KWDZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 22:25:49 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3466 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab1KWDZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 22:25:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6538"; a="140171774"
Message-ID: <4ECC67B9.4050306@codeaurora.org>
Date: Tue, 22 Nov 2011 19:25:45 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org
Subject: Re: [PATCH 0/7] Introducing a generic AMP framework
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1319536106-25802-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 02:48 AM, Ohad Ben-Cohen wrote:
> Modern SoCs typically employ a central symmetric multiprocessing (SMP)
> application processor running Linux, with several other asymmetric
> multiprocessing (AMP) heterogeneous processors running different instances
> of operating system, whether Linux or any other flavor of real-time OS.
>
> OMAP4, for example, has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP.
> Typically, the dual cortex-A9 is running Linux in a SMP configuration, and
> each of the other three cores (two M3 cores and a DSP) is running its own
> instance of RTOS in an AMP configuration.
>
> AMP remote processors typically employ dedicated DSP codecs and multimedia
> hardware accelerators, and therefore are often used to offload cpu-intensive
> multimedia tasks from the main application processor. They could also be
> used to control latency-sensitive sensors, drive 'random' hardware blocks,
> or just perform background tasks while the main CPU is idling.
>

I understand that I might be saying this pretty late in the review, but 
can we please stop calling these as AMP configurations? IMHO, in the 
kernel, we should limit the terms AMP and SMP to be based on the 
processors/CPUs on which this specific instance of the Linux kernel can 
schedule processes on.

With the definition of AMP that you are trying to use, even a Intel 
386/486 machine with just one Intel core will be an AMP system. I'm sure 
even those old PCs had other processors inside other devices (HDDs, 
GPUs, etc) executing random firmware.

So, what would you call Intel dual core machines? SMP-AMP? Your proposed 
use of AMP muddles these terms and makes them useless. I think AMP 
should be reserved for things like the ARM Big-little architecture, etc, 
where the CPUs in which the kernel schedules processes are not identical.

Sorry for the rant, this naming just rubs me the wrong way. I definitely 
appreciate the idea behind these patches.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
