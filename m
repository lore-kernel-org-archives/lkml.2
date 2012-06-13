Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2FMVf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:35:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51379 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2FMVf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:35:27 -0400
Message-ID: <1339623321.8980.66.camel@twins>
Subject: Re: [PATCH 2/4] x86: Track minimum microcode revision globally v2
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 13 Jun 2012 23:35:21 +0200
In-Reply-To: <1339618842-26636-3-git-send-email-andi@firstfloor.org>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
	 <1339618842-26636-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 13:20 -0700, Andi Kleen wrote:
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index 8a2ce8f..b589c7a 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -215,6 +215,7 @@ static int apply_microcode_amd(int cpu)
>         pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
>         uci->cpu_sig.rev = rev;
>         c->microcode = rev;
> +       update_min_microcode(c);
>  
>         return 0;
>  }
> diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
> index 899057b..63e8a71 100644
> --- a/arch/x86/kernel/microcode_intel.c
> +++ b/arch/x86/kernel/microcode_intel.c
> @@ -326,6 +326,7 @@ static int apply_microcode(int cpu)
>         uci->cpu_sig.rev = val[1];
>         c->microcode = val[1];
>  
> +       update_min_microcode(c);
>         return 0;
>  } 

This would really much better live in common code where it can be
preemptible in some sites. There really is no need for this to be
non-preemptible.
