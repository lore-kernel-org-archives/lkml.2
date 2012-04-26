Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2DZK2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:28:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34867 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755046Ab2DZK2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:28:45 -0400
Date: Thu, 26 Apr 2012 11:28:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yilu Mao <ylmao@marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Baohua.Song@csr.com" <Baohua.Song@csr.com>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: cache-l2x0.c: save aux ctrl for resume in case
 that l2x0 is enabled before init
Message-ID: <20120426102815.GE18136@arm.com>
References: <1335235280-25148-1-git-send-email-ylmao@marvell.com>
 <20120424082810.GA9367@arm.com>
 <4F98D659.4030709@marvell.com>
 <20120426083554.GB18136@arm.com>
 <4F99148B.4020900@marvell.com>
 <20120426094400.GD18136@arm.com>
 <4F991ED6.8060109@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F991ED6.8060109@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 11:09:26AM +0100, Yilu Mao wrote:
> On 04/26/2012 05:44 PM, Catalin Marinas wrote:
> > On Thu, Apr 26, 2012 at 10:25:31AM +0100, Yilu Mao wrote:
> >> On 04/26/2012 04:35 PM, Catalin Marinas wrote:
> >>> On Thu, Apr 26, 2012 at 06:00:09AM +0100, Yilu Mao wrote:
> >>>> On 04/24/2012 04:28 PM, Catalin Marinas wrote:
> >>>>> On Tue, Apr 24, 2012 at 03:41:20AM +0100, Yilu Mao wrote:
> >>>>>> +	l2x0_saved_regs.aux_ctrl = aux;
> >>>>>> +
> >>>>>>     	aux&= aux_mask;
> >>>>>>     	aux |= aux_val;
> >>>>>
> >>>>> I think that's the wrong place to save it, it should be after the
> >>>>> masking was done.
> >>>>>
> >>>>> Anyway, if we cannot write this register in l2x0_init() because the L2
> >>>>> was enabled, do we expect the L2 to be disabled during resume?
> >>>>>
> >>>> Sorry, I don't think so.
> >>>> This is the right place to save it because we must make sure the saved
> >>>> aux_ctrl is the same as what it is set.
> >>>> If we save it after masking was done, the saved value will be different
> >>>> because we can't actually change the real setting.
> >>>
> >>> And since we can't actually change the real setting on the resume path,
> >>> why do we need to save it anyway. Is your L2 cache disabled on the
> >>> resume path but not on the cold boot one?
> >>
> >> We can't change L2 aux ctrl setting when do init because it has been
> >> enabled.
> >
> > This is normally for the case where the kernel running in non-secure
> > mode is not allowed to write the L2 aux ctrl register. Does this
> > permission change with core idle?
> >
> Yes, your understanding of previous mail is right. The L2 is enabled on 
> code boot and it is disabled on the resume in our case.

But the kernel either runs in secure mode or the non-secure access to
this register is allowed.

> So if we don't have such patch, when core idle exit, L2 cache aux ctrl 
> register will be set to 0x0 because l2x0_saved_regs.aux_ctrl is not 
> initialized.

You could still make sure that the mask passed doesn't affect the
original setting and save it after masking.

-- 
Catalin
