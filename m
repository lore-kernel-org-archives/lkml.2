Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2FMVbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:31:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:40214 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2FMVbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:31:03 -0400
Message-ID: <1339623054.8980.64.camel@twins>
Subject: Re: [PATCH 3/4] perf, x86: check ucode before disabling PEBS on
 SandyBridge v3
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 13 Jun 2012 23:30:54 +0200
In-Reply-To: <1339618842-26636-4-git-send-email-andi@firstfloor.org>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
	 <1339618842-26636-4-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 13:20 -0700, Andi Kleen wrote:

> +static int check_pebs_quirks(void)
> +{
> +	int model = cpu_data(smp_processor_id()).x86_model;
> +
> +	/* do not have PEBS to begin with */
> +	if (!x86_pmu.pebs)
> +		return 0;
> +
> +	/*
> +	 * check ucode version for SNB, SNB-EP
> +	 */
> +	if ((model == 42 && boot_cpu_data.microcode < 0x28) ||
> +		(model == 45 && boot_cpu_data.microcode < 0x618)) {

Stephane actually wrote:

"Ok, so to close on this, I tried the 6/6/2012 ucode update on a few
SNB-EP systems.

I got two answers depending on the stepping:
C1 (stepping 6) -> 0x618
C2 (stepping 7) -> 0x70c

So we need to check x86_mask for stepping and adjust the value of
snb_ucode_rev accordingly for model 45."

