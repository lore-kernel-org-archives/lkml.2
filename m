Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0L3UOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 15:14:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50401 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab0L3UOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 15:14:37 -0500
Message-ID: <4D1CE80D.3050503@zytor.com>
Date: Thu, 30 Dec 2010 12:14:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, eric.dumazet@gmail.com, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, penberg@kernel.org,
        shaohui.zheng@intel.com, rientjes@google.com
Subject: Re: [PATCHSET] x86: unify x86_32 and 64 NUMA init paths, take#4
References: <1293731369-10851-1-git-send-email-tj@kernel.org>
In-Reply-To: <1293731369-10851-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2010 09:49 AM, Tejun Heo wrote:
> 
> The only change from the last take[L] is that it's now based on
> tip/x86/numa.  Unfortunately, some of the collisions weren't trivial
> and led to some ugliness.
> 
> Commit c1c3443c ("x86, numa: Fake node-to-cpumask for NUMA emulation")
> introduced hard dependency on x86_64 into numa_add/remove_cpu() when
> CONFIG_NUMA_EMU is enabled.  0015 has been updated so that the 32/64
> bit common versions used when !CONFIG_NUMA_EMU are in numa.c while
> CONFIG_NUMA_EMU variants are in numa_64.c.
> 
> This is ugly but still better than before.  IIUC, Shaohui's patchsets
> is going to unify NUMA emulation across 32 and 64bit, which should
> remove the above ugliness.  I haven't looked through the patchset yet
> but after skimming through the current NUMA_EMU code, here are some of
> my thoughts, FWIW.
> 
> * There's no reason for different NUMA config methods to construct
>   different data structures.  They all, including 32bit, can build a
>   single set of data structures.
> 
> * Then, unification of NUMA_EMU would naturally follow.  There's no
>   reason to think about whether the underlying NUMA and proximity
>   information is provided by ACPI, AMD or whatever.  It just needs to
>   manipulate the processed data.
> 
> Let's _please_ head that way instead of adding more gluing codes and
> hacks everywhere.  It would be a bit more churn but I don't think
> there's any other sustainable way.
> 

Agreed 100%.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

