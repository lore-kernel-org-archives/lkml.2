Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2FNJKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:10:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40910 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab2FNJKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:10:06 -0400
Date: Thu, 14 Jun 2012 11:10:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] x86: Track minimum microcode revision globally v2
Message-ID: <20120614091001.GA22155@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, eranian@google.com,
	peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
 <1339618842-26636-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339618842-26636-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 01:20:40PM -0700, Andi Kleen wrote:
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

You still haven't told me what's the use of this printk statement to the
user. Should she update her microcode, buy a new box or go up in flames?

-- 
Regards/Gruss,
    Boris.
