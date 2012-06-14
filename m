Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2FNMh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:37:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40104 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab2FNMh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:37:57 -0400
Date: Thu, 14 Jun 2012 14:37:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        peterz@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] x86: Track minimum microcode revision globally v2
Message-ID: <20120614123759.GC13629@x1.osrc.amd.com>
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
> +void update_min_microcode(struct cpuinfo_x86 *c)
> +{
> +	int i;
> +
> +	for_each_online_cpu (i)
> +		if (cpu_data(i).microcode < c->microcode)
> +			return;
> +	if (boot_cpu_data.microcode != c->microcode) {
> +		boot_cpu_data.microcode = c->microcode;
> +		pr_info("Minimum microcode revision updated to %x\n", c->microcode);

This needs to be stating explicitly that the ucode version is in hex -
0x%x - as everywhere else in the kernel where we output ucode version.

Ditto for the remaining printks which will end up in the final version
of your patchset.

-- 
Regards/Gruss,
Boris.
