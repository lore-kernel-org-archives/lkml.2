Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1EYHGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:06:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab1EYHGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:06:13 -0400
Date: Wed, 25 May 2011 09:06:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525070604.GE429@elte.hu>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -111,6 +111,8 @@ struct cpuinfo_x86 {
>  	/* Index into per_cpu list: */
>  	u16			cpu_index;
>  #endif
> +	/* CPU update signature */
> +	u32			x86_cpu_update;

Btw,. there's one subtle thing here: it's possible to have *different* 
microcode versions on different CPUs in te system.

This can happen if for example the BIOS somehow does not apply the right 
microcode to all CPUs. It can also happen if physically different microcode 
version CPUs are mixed. In theory people can mix steppings as well.

Would you be interested in adding a quick debugging check after all CPUs have 
been brought online, and print some very visible boot warning message if 
there's a mismatch between the steppings or microcode versions? Perhaps also 
taint the kernel.

Having non-updated microcode is one thing, but having *mixed* versions can 
introduce its own set of problems: there are workarounds that have to be 
activated on all CPUs, otherwise the result may be undefined.

We did not check for this before, so this would be a separate patch as well.

This should be done in a generic way, so it should work with other x86 CPUs as 
well.

Thanks,

	Ingo
