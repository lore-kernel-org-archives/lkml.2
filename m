Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab1FPTkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 15:40:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7417 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757775Ab1FPTkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 15:40:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6379"; a="98001773"
Message-ID: <4DFA5C2E.40507@codeaurora.org>
Date: Thu, 16 Jun 2011 12:40:30 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [RFC] Add Arm cpu topology definition
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
In-Reply-To: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 01:49 AM, Vincent Guittot wrote:
> +config SCHED_MC
> +	bool "Multi-core scheduler support"
> +	depends on SMP && ARM_CPU_TOPOLOGY
> +	default n
> +	help
> +	  Multi-core scheduler support improves the CPU scheduler's decision
> +	  making when dealing with multi-core CPU chips at a cost of slightly
> +	  increased overhead in some places. If unsure say N here.
> +
> +config SCHED_SMT
> +	bool "SMT scheduler support"
> +	depends on SMP && ARM_CPU_TOPOLOGY
> +	default n
> +	help
> +	  Improves the CPU scheduler's decision making when dealing with
> +	  MultiThreading at a cost of slightly increased overhead in some
> +	  places. If unsure say N here.
> +

The default is already n so you can drop those two lines.

> +		 * This is a multiprocessor system
> +		 * multiprocessor format & multiprocessor mode field are set
> +		 */
> +
> +		if (mpidr & (0x1 << 24)) {
> +			/* core performance interdependency */
> +			cpuid_topo->thread_id = (mpidr & 0x3);
> +			cpuid_topo->core_id =  ((mpidr >> 8) & 0xF);
> +			cpuid_topo->socket_id = ((mpidr >> 16) & 0xFF);
> +		} else {
> +			/* normal core interdependency */
> +			cpuid_topo->thread_id = -1;
> +			cpuid_topo->core_id = (mpidr & 0x3);
> +			cpuid_topo->socket_id = ((mpidr >> 8) & 0xF);
> +		}
> +

The ARM ARM says these fields are IMPLEMENTATION DEFINED meaning that
different vendors may attribute different meaning to these fields if
they wish. Does that mean this should be a platform_*() function?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

