Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab2BULF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:05:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36209 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2BULFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:05:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel@numascale-asia.com designates 10.204.173.11 as permitted sender) smtp.mail=daniel@numascale-asia.com
Message-ID: <4F437A71.6000402@numascale-asia.com>
Date: Tue, 21 Feb 2012 11:05:21 +0000
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Steffen Persvold <sp@numascale.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] x86: Remove wrong error message in x86_default_fixup_cpu_id
References: <20120220171705.GA17069@alberich.amd.com> <20120221102725.GC14274@aftab>
In-Reply-To: <20120221102725.GC14274@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/2012 10:27, Borislav Petkov wrote:
> On Mon, Feb 20, 2012 at 06:17:05PM +0100, Andreas Herrmann wrote:
>
> It's only called from amd.c:srat_detect_node(). The introduced
> condition for calling the fixup code is true for all AMD multi-node
> processors, e.g. Magny-Cours and Interlagos. There we have 2 NUMA
> nodes on one socket. And thus there are cores having different
> numa-node-id but with equal phys_proc_id. For example on such a system
> we now get
>
> [    0.228109] Booting Node   0, Processors  #1
> [    0.232337] smpboot cpu 1: start_ip = 83000
> [    0.252088]  #2
> [    0.253746] smpboot cpu 2: start_ip = 83000
> [    0.272086]  #3
> [    0.276018] smpboot cpu 3: start_ip = 83000
> [    0.296088]  #4
> [    0.297745] smpboot cpu 4: start_ip = 83000
> [    0.316088]  #5
> [    0.320021] smpboot cpu 5: start_ip = 83000
> [    0.340113]  Ok.
> [    0.342324] Booting Node   1, Processors  #6
> [    0.344344] smpboot cpu 6: start_ip = 83000
> [    0.016000] NUMA core number 1 differs from configured core number 0
> [    0.372110]  #7
> [    0.373771] smpboot cpu 7: start_ip = 83000
> [    0.016000] NUMA core number 1 differs from configured core number 0
> [    0.396104]  #8
> [    0.397764] smpboot cpu 8: start_ip = 83000
> [    0.016000] NUMA core number 1 differs from configured core number 0
> [    0.420109]  #9
> [    0.421773] smpboot cpu 9: start_ip = 83000
> [    0.016000] NUMA core number 1 differs from configured core number 0
> [    0.444113]  #10
> [    0.445865] smpboot cpu 10: start_ip = 83000
> [    0.016000] NUMA core number 1 differs from configured core number 0
> [    0.468111]  #11
> [    0.472030] smpboot cpu 11: start_ip = 83000
> [    0.016000] NUMA core number 1 differs from configured core number 0
>
> These NUMA core numbering error messages are plain wrong.
>
> The confusing/misleading error message was introduced with commit
> 64be4c1c2428e148de6081af235e2418e6a66dda (x86: Add x86_init platform
> override to fix up NUMA core numbering) and should be removed.
>
> Reported-by: Borislav Petkov<borislav.petkov@amd.com>
> Signed-off-by: Andreas Herrmann<andreas.herrmann3@amd.com>
> ---
>   arch/x86/kernel/cpu/common.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> BTW, I wonder why the fixup code isn't called from the Intel path.  At
> least the mentioned patch suggests that something more generic was
> introduced here.
> Right, and I would remove the check in amd.c:srat_detect_node() instead
> of removing the printk statement in the default implementation.
>
> IOW, we need more info on why the check was added only to the AMD path?
> Daniel?

The check and fixup wasn't needed in the Intel path thus far, so wasn't 
added.

We could specialise the 'if (c->phys_proc_id != node)' test to check for 
x86_cpuinit.fixup_cpu_id being NULL and drop the default override, if 
that is preferred?

Thanks,
   Daniel

-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia

