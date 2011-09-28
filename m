Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab1I1RAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:00:55 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:40894 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab1I1RAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:00:54 -0400
Date: Wed, 28 Sep 2011 18:59:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@suse.com>
Cc: tglx@linutronix.de, hpa@zytor.com,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] x86-64: fix CFI data for interrupt frames
Message-ID: <20110928165917.GC10084@elte.hu>
References: <4E8360200200007800058467@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8360200200007800058467@nat28.tlf.novell.com>
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


* Jan Beulich <JBeulich@suse.com> wrote:

> The patch titled "x86: Don't use frame pointer to save old stack on irq
> entry" did not properly adjust CFI directives, so this patch is a
> follow-up to that one.
> 
> With the old stack pointer no longer stored in a callee-saved register
> (plus some offset), we now have to use a CFA expression to describe the
> memory location where it is being found. This requires the use of
> .cfi_escape (allowing arbitrary byte streams to be emitted into
> .eh_frame), as there is no .cfi_def_cfa_expression (which also cannot
> reasonably be expected, as it would require a full expression parser).
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> 
> ---
>  arch/x86/include/asm/dwarf2.h |    2 ++
>  arch/x86/kernel/entry_64.S    |   14 +++++++++-----
>  2 files changed, 11 insertions(+), 5 deletions(-)

Applied all 3 patches you sent, thanks Jan! (the tip-bot notification 
depends on korg being fully restored.)

Thanks,

	Ingo
