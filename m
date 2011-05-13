Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab1EMMkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 08:40:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39110 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759028Ab1EMMki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 08:40:38 -0400
Date: Fri, 13 May 2011 14:40:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, UV: Reformat uv_mmrs.h - no code changes
Message-ID: <20110513124029.GB3924@elte.hu>
References: <20110512133308.GA17113@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512133308.GA17113@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> No code changes.  Reformat file to eliminate errors caught
> by checkpatch.pl
> 
> Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> ---
>  arch/x86/include/asm/uv/uv_mmrs.h | 1147 ++++++++++++++++++--------------------
>  1 file changed, 573 insertions(+), 574 deletions(-)

Firstly, the patch does not apply to -tip cleanly.

Secondly, and more importantly, you are only addressing checkpatch errors but 
you are not looking at the end result! The goal is to make the code nicer to 
look at.

 Good example: uvh_event_occurred0_u, uvh_lb_bau_intd_software_acknowledge_u
  Bad example: uvh_bau_data_config_u and most of the other definitions!

There's a couple of other problems as well.

Why the heck is this symbol:

  #define UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT 16

56 characters long?! Was there possibly no way to make it even longer?

And of course, once used, this symbol craps up the code in 
arch/x86/platform/uv/tlb_uv.c ...

Using BAU_MISC_ACK_PERIOD_SHIFT would be like 3 times shorter, and still as 
obvious. Or if these are the result of some Verilog tooling dependency then 
please keep these tucked away in the .h and use some sensible symbol instead, 
never pollute the .c file with the insanely long symbol names!

Also, if you look at the line of definitions you will see the same kind of 
ugliness you can see at uvh_bau_data_config_u et al.

And then i have not even started about enable_programmed_initial_priority 
structure fields.

Thanks,

	Ingo
