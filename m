Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2FNMUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:20:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33437 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab2FNMUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:20:22 -0400
Date: Thu, 14 Jun 2012 14:20:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] x86: Track minimum microcode revision globally v2
Message-ID: <20120614122022.GB13629@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, eranian@google.com,
	peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
 <1339618842-26636-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339618842-26636-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 01:20:40PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For bug workarounds depending on microcode revisions we need to
> know the minimum microcode revision shared by all CPUs.
> 
> This patch adds infrastructure to track this.
> 
> Every time microcode is updated we update a global variable for
> the minimum microcode revision of all the CPUs in the system.
> At boot time we use the lowest available microcode (and warn
> if  they are inconsistent)
> 
> At CPU hotplug or S3 resume time there is a short race window
> where something might run on the CPUs but before the microcode
> update notifier runs. For the current workarounds that need this
> this is acceptable and shouldn't be a problem.
> 
> Only tested on Intel CPUs, but should work for AMD too.
> 
> v2: Use boot_cpu_data.microcode to track minimum revision (H. Peter Anvin)
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---

[ … ]

> +/*
> + * Track the minimum global microcode version.  On early bootup assume
> + * the BIOS set all CPUs to the same revision. If that's not the case
> + * some code may be already running assuming the newer revision, but
> + * there's not much we can do about that (but it's unlikely to be
> + * problem in early bootup)
> + */
> +__cpuinit void boot_update_min_microcode(struct cpuinfo_x86 *c)
> +{	
> +	static int boot_min_microcode;
> +
> +	if (!boot_min_microcode) {
> +		boot_min_microcode = c->microcode;
> +		boot_cpu_data.microcode = c->microcode;
> +	} else if (c->microcode < boot_min_microcode) {
> +		pr_warn("CPU %d has lower microcode revision %x at boot than boot CPU (%x)\n",
> +			smp_processor_id(), 
> +			c->microcode,
> +			boot_min_microcode);
> +		boot_cpu_data.microcode = c->microcode;
> +	}


Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all y
Applying: x86: Track minimum microcode revision globally v2
/home/boris/kernel/.git/rebase-apply/patch:52: trailing whitespace.
{
/home/boris/kernel/.git/rebase-apply/patch:60: trailing whitespace.
                        smp_processor_id(), 
warning: 2 lines add whitespace errors.

-- 
Regards/Gruss,
Boris.
