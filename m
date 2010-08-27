Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0H0PaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 11:30:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2805 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab0H0PaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 11:30:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52334635"
Subject: Re: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
From: Daniel Walker <dwalker@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <1282917280.26355.33.camel@e102109-lin.cambridge.arm.com>
References: <1282712273-344-4-git-send-email-johlstei@codeaurora.org>
	 <1282917280.26355.33.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 08:29:38 -0700
Message-ID: <1282922978.5075.13.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 14:54 +0100, Catalin Marinas wrote:
> On Wed, 2010-08-25 at 05:57 +0100, Jeff Ohlstein wrote:
> > From: Daniel Walker <dwalker@codeaurora.org>
> > 
> > ScorpionMP does not have the SMP/nAMP and TLB ops broadcasting bits in
> > ACTLR.
> > 
> > Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> > Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
> > ---
> >  arch/arm/mm/proc-v7.S |   24 ++++++++++++++++++++++++
> >  1 files changed, 24 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> > index 7aaf88a..98fd7e5 100644
> > --- a/arch/arm/mm/proc-v7.S
> > +++ b/arch/arm/mm/proc-v7.S
> > @@ -196,6 +196,7 @@ __v7_setup:
> >         orreq   r0, r0, #(1 << 6) | (1 << 0)    @ Enable SMP/nAMP mode and
> >         mcreq   p15, 0, r0, c1, c0, 1           @ TLB ops broadcasting
> >  #endif
> > +__v7_msm_setup:
> >         adr     r12, __v7_setup_stack           @ the local stack
> >         stmia   r12, {r0-r5, r7, r9, r11, lr}
> >         bl      v7_flush_dcache_all
> 
> It may be better to move the generic __v7_setup here and have a specific
> entry for ARM Ltd cores (mask 0xff0f0000 and value 0x410f0000).

I'm not sure I follow you.. Are you saying there are other cpu's that
don't need the SMP stuff at the top of __v7_setup ?

> In general, I would have liked a different way (still ID-based) of
> handling such issues without duplicating the whole structure. But I see
> this becoming the standard as proc-v6.S follows it as well.

This whole thing was something Russell specifically asked for (and
practically wrote for me).

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


