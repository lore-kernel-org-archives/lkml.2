Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2K2UKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:10:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:55593 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2K2UKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:10:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="256800267"
From: Andi Kleen <andi@firstfloor.org>
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
Date: Thu, 29 Nov 2012 12:09:37 -0800
In-Reply-To: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
	(Jim Kukunas's message of "Thu, 8 Nov 2012 13:47:44 -0800")
Message-ID: <m2obigf9xa.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Kukunas <james.t.kukunas@linux.intel.com> writes:
> +
> +	/* ymm0 = x0f[16] */
> +	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
> +
> +	while (bytes) {
> +#ifdef CONFIG_X86_64
> +		asm volatile("vmovdqa %0, %%ymm1" : : "m" (q[0]));
> +		asm volatile("vmovdqa %0, %%ymm9" : : "m" (q[32]));
> +		asm volatile("vmovdqa %0, %%ymm0" : : "m" (p[0]));
> +		asm volatile("vmovdqa %0, %%ymm8" : : "m" (p[32]));

This is somewhat dangerous to assume registers do not get changed
between assembler statements or assembler statements do not get
reordered. Better always put such values into explicit variables or
merge them into a single asm statement.

asm volatile is also not enough to prevent reordering. If anything
you would need a memory clobber.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
