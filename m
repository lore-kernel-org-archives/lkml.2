Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2BUK1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:27:37 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60469 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2BUK1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:27:36 -0500
Date: Tue, 21 Feb 2012 11:27:25 +0100
From: Borislav Petkov <bp@amd64.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Steffen Persvold <sp@numascale.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] x86: Remove wrong error message in
 x86_default_fixup_cpu_id
Message-ID: <20120221102725.GC14274@aftab>
References: <20120220171705.GA17069@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220171705.GA17069@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 06:17:05PM +0100, Andreas Herrmann wrote:
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
> Reported-by: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/cpu/common.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> BTW, I wonder why the fixup code isn't called from the Intel path.  At
> least the mentioned patch suggests that something more generic was
> introduced here.

Right, and I would remove the check in amd.c:srat_detect_node() instead
of removing the printk statement in the default implementation.

IOW, we need more info on why the check was added only to the AMD path?
Daniel?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
