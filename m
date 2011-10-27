Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab1J0KrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 06:47:02 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:49907 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1J0KrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 06:47:00 -0400
Message-ID: <4EA93699.9000101@numascale.com>
Date: Thu, 27 Oct 2011 12:46:49 +0200
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/3] Add multi-node boot support
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com> <1319609230-18897-2-git-send-email-daniel@numascale-asia.com> <20111027073029.GD15923@elte.hu>
In-Reply-To: <20111027073029.GD15923@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 09:30, Ingo Molnar wrote:
[]
>> +		c->phys_proc_id = node;
>> +		per_cpu(cpu_llc_id, cpu) = node;
>> +	}
>
> But more importantly, please first explain why the quirk is needed
> (the patch only explains what it does but does not explain why it
> needs these changes - other NUMA systems are able to boot without
> this quirk).

The issue is that since all AMD CPUs gets their initial APIC Id assigned 
in the power up process on each individual system, when connecting all 
systems through Numachip we end up with multiple AMD CPUs with the same 
"phys_proc_id". This in turn lets Linux think they have the same llc_id 
and we get a oops somewhere in the scheduler code later on (when 
scheduler is configured to be numa aware).

>
> If it's absolutely needed then add a proper quirk handler instead of
> polluting the generic code.
>

We wanted to reuse as much of the generic AMD code as possible, but it's 
tricky because most of that code is based around a single HT fabric 
design, whereas a NumaChip based systems consists of several HT fabrics 
connected together thus you will have identical NorthBridge IDs (0-7) 
etc. shared between all systems.

How would you suggest we add a quirk handler for it ?

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
