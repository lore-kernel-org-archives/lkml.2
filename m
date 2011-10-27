Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1J0Hqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:46:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1J0Hq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:46:28 -0400
Date: Thu, 27 Oct 2011 09:44:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/3] Add Numachip APIC support
Message-ID: <20111027074449.GF15923@elte.hu>
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel J Blueman <daniel@numascale-asia.com> wrote:

> +	numachip_write_local_csr(NUMACHIP_CSR_G3_EXT_INTERRUPT_GEN,
> +				 int_gen.v);

> +	numachip_write_local_csr(NUMACHIP_CSR_G3_EXT_INTERRUPT_GEN,
> +				 int_gen.v);

> +	numachip_write_local_csr(NUMACHIP_CSR_G3_EXT_INTERRUPT_GEN,
> +				 int_gen.v);

Please don't break the line in an ugly way like that just to placate 
checkpatch.pl.

checkpatch.pl is right to complain about the too long line here - but 
your fix is wrong: the proper approach is to make the code *shorter*.

So for example instead of numachip_write_local_csr() you could 
abbreviate it to something obvious such as:

	write_lcsr()

it's not like these will be used outside of the Numachip code, so 
there's no confusion from the missing numachip_ prefix.

write_gcsr() can be used for the global registers.

Likewise, NUMACHIP_CSR_G3_EXT_INTERRUPT_GEN is way too long as well - 
you can easily rename it to CSR_G3_EXT_IRQ_GEN or such, without 
losing expressive value. Then it could be written in the much shorter 
form of:

	write_lcsr(CSR_G3_EXT_IRQ_GEN, irq_gen.v);

... and magically checkpatch.pl won't complain anymore.

Likewise there's ton's of other way too long names in the patch as 
well - please try to abbreviate them wherever that can be done 
without losing expressive value.

Note, we don't want to over-do it: we obviously don't want to shorten 
names to CSRG3EIG kind of gibberish, so *some* length is of course 
acceptable.

When a line becomes too long then leave it too long instead of 
breaking it - line length up to say 100 cols in width are still OK, 
as long as the surrounding code does not have obvious deficiencies 
like too much complexity.

Note, while the merge window is in progress already, i think we can 
still add these patches slightly outside the merge window as well, as 
they add new hardware support and don't risk regressions elsewhere - 
if all the structural and fine-detail problems i pointed out during 
review are fixed.

Thanks,

	Ingo
