Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0HaMS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:18:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39341 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317Ab0HaMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:18:56 -0400
Subject: Re: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
In-Reply-To: <1282938790.5075.25.camel@m0nster>
References: <1282926826.5075.21.camel@m0nster>
	 <1282927746.26355.74.camel@e102109-lin.cambridge.arm.com>
	 <1282938790.5075.25.camel@m0nster>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 31 Aug 2010 13:18:36 +0100
Message-ID: <1283257116.28248.20.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Aug 2010 12:18:37.0337 (UTC) FILETIME=[A3967890:01CB4906]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 20:53 +0100, Daniel Walker wrote:
> On Fri, 2010-08-27 at 17:49 +0100, Catalin Marinas wrote:
> 
> > > So your saying it makes more sense to change the msm entry into the
> > > default entry, and make the current default into the
> > > ARM11MPCore/Cortex-A9 entry?
> >
> > So my opinion is to not add any specific msm code but make the
> > __v7_setup skip the ACTLR bit setting. Then add an entry for Cortex-A9
> > to set those bits.
> >
> 
> how about this? Naming is of course flexible ..

I cc'ed Santosh as well. I'm not sure whether TI are using a Cortex-A9
but with different manufacturer field (I suspect it's still 0x41).

> ScorpionMP does not have the SMP/nAMP and TLB ops broadcasting bits in
> ACTLR. These bits are only used on ARM11MPCore and Cortex-A9 from arm.
> This patch just makes it so no other arm core ends up getting these
> bits set.
> 
> Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> 
> ---
>  arch/arm/mm/proc-v7.S |   26 +++++++++++++++++++++++++-
>  1 files changed, 25 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> index 7aaf88a..e1b5492 100644
> --- a/arch/arm/mm/proc-v7.S
> +++ b/arch/arm/mm/proc-v7.S
> @@ -189,13 +189,14 @@ cpu_v7_name:
>   *     It is assumed that:
>   *     - cache type register is implemented
>   */
> -__v7_setup:
> +__v7_armmp_setup:

Maybe __v7_ca9mp_setup. Future MP processors from ARM may not need this
bit set.

> +__v7_armmp_proc_info:
> +       .long   0x410f0000              @ Required ID value
> +       .long   0xff0f0000              @ Mask for ID

We could restrict it to:

	.long	0x410fc090
	.long	0xff0ffff0

Otherwise the patch looks fine. Thanks.

-- 
Catalin

