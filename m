Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab0HaQoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:44:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34869 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0HaQog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:44:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6091"; a="52890948"
Subject: Re: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
From: Daniel Walker <dwalker@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
In-Reply-To: <1283257116.28248.20.camel@e102109-lin.cambridge.arm.com>
References: <1282926826.5075.21.camel@m0nster>
	 <1282927746.26355.74.camel@e102109-lin.cambridge.arm.com>
	 <1282938790.5075.25.camel@m0nster>
	 <1283257116.28248.20.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 09:44:15 -0700
Message-ID: <1283273055.11790.0.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 13:18 +0100, Catalin Marinas wrote:
> On Fri, 2010-08-27 at 20:53 +0100, Daniel Walker wrote:
> > On Fri, 2010-08-27 at 17:49 +0100, Catalin Marinas wrote:
> > 
> > > > So your saying it makes more sense to change the msm entry into the
> > > > default entry, and make the current default into the
> > > > ARM11MPCore/Cortex-A9 entry?
> > >
> > > So my opinion is to not add any specific msm code but make the
> > > __v7_setup skip the ACTLR bit setting. Then add an entry for Cortex-A9
> > > to set those bits.
> > >
> > 
> > how about this? Naming is of course flexible ..
> 
> I cc'ed Santosh as well. I'm not sure whether TI are using a Cortex-A9
> but with different manufacturer field (I suspect it's still 0x41).
> 
> > ScorpionMP does not have the SMP/nAMP and TLB ops broadcasting bits in
> > ACTLR. These bits are only used on ARM11MPCore and Cortex-A9 from arm.
> > This patch just makes it so no other arm core ends up getting these
> > bits set.
> > 
> > Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> > 
> > ---
> >  arch/arm/mm/proc-v7.S |   26 +++++++++++++++++++++++++-
> >  1 files changed, 25 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> > index 7aaf88a..e1b5492 100644
> > --- a/arch/arm/mm/proc-v7.S
> > +++ b/arch/arm/mm/proc-v7.S
> > @@ -189,13 +189,14 @@ cpu_v7_name:
> >   *     It is assumed that:
> >   *     - cache type register is implemented
> >   */
> > -__v7_setup:
> > +__v7_armmp_setup:
> 
> Maybe __v7_ca9mp_setup. Future MP processors from ARM may not need this
> bit set.

Ok ..

> > +__v7_armmp_proc_info:
> > +       .long   0x410f0000              @ Required ID value
> > +       .long   0xff0f0000              @ Mask for ID
> 
> We could restrict it to:
> 
> 	.long	0x410fc090
> 	.long	0xff0ffff0
> 
> Otherwise the patch looks fine. Thanks.

Ok, I'll add this.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

