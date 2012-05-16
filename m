Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab2EPSil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:38:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57739 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2EPSii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:38:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6713"; a="189300365"
Date: Wed, 16 May 2012 11:38:35 -0700
From: David Brown <davidb@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] gpio/msm-v1: re-read IRQ flags on each iteration
Message-ID: <20120516183835.GA8120@codeaurora.org>
References: <1336738032-14940-1-git-send-email-linus.walleij@stericsson.com>
 <20120511174112.D9EEE3E0791@localhost>
 <20120516010919.GA1295@codeaurora.org>
 <CACRpkdYWfmwAZS=KAFkUO1RSV5=YD-PnO3cHfs=P+eoQDZCsZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYWfmwAZS=KAFkUO1RSV5=YD-PnO3cHfs=P+eoQDZCsZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 09:23:33AM +0200, Linus Walleij wrote:
> On Wed, May 16, 2012 at 3:09 AM, David Brown <davidb@codeaurora.org> wrote:
> > On Fri, May 11, 2012 at 11:41:12AM -0600, Grant Likely wrote:
> 
> >> I'll need an ack from an msm developer before applying this.
> >
> > I though I saw Jeff Ohlstein reply, but I'm not finding that message.
> 
> He was replying to a similar patch affecting the DMA controller
> interrupt-like construct.
> 
> > I believe this patch is actually incorrect.  The register needs to
> > only be read once, and the bits walked through.  If another interrupt
> > comes in during the loop, the interrupt will remain asserted, and we
> > will re-enter the irq handler.  I suppose it could be wrapped in yet
> > another loop, but I'm not sure it is worth it.
> 
> OK the code doesn't say really. (It did say something like that
> in the DMA controller). It's quite uncommon with these type of
> latched-clear registers (reading IRQ status clears the flags) type
> of hardware so maybe it should be commented.

I'll see if I can get confirmation on it.

> > I'm pretty sure the code works as it is, since it is the same as the
> > code in the Android kernel.
> 
> The problem with this bug is that it often works until you get a
> demanding case. On the VIC I guess it wasn't noticed until tested with
> a device that raised a storm of IRQs so the handler started missing
> them.

At one point, the target got a lot of use, so I'm going to guess the
current code is correct.  I'll see if I can dig up a definitive
answer, though.  Since I don't have one to even test on, I'm a little
reluctant to change the code, though.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
