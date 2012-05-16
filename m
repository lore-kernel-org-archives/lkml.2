Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967246Ab2EPBJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:09:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57029 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932Ab2EPBJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:09:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6712"; a="189023064"
Date: Tue, 15 May 2012 18:09:19 -0700
From: David Brown <davidb@codeaurora.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpio/msm-v1: re-read IRQ flags on each iteration
Message-ID: <20120516010919.GA1295@codeaurora.org>
References: <1336738032-14940-1-git-send-email-linus.walleij@stericsson.com>
 <20120511174112.D9EEE3E0791@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511174112.D9EEE3E0791@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:41:12AM -0600, Grant Likely wrote:
> On Fri, 11 May 2012 14:07:12 +0200, Linus Walleij <linus.walleij@stericsson.com> wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> > 
> > We have recently found a number or erroneous IRQ handlers in
> > the kernel where the flag iterator loop miss IRQs that get
> > raised when the loop is executing. This was spotted in the
> > MSM v1 GPIO driver by Julia Lawall using this cocinelle
> > snippet:
> > 
> > @@
> > expression pending,gedr,e1;
> > statement S;
> > @@
> > 
> > *pending = readl(gedr);
> > ... when != pending = e1
> > while (pending) S
> > 
> > Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Thanks Linus,
> 
> I'll need an ack from an msm developer before applying this.

I though I saw Jeff Ohlstein reply, but I'm not finding that message.
I believe this patch is actually incorrect.  The register needs to
only be read once, and the bits walked through.  If another interrupt
comes in during the loop, the interrupt will remain asserted, and we
will re-enter the irq handler.  I suppose it could be wrapped in yet
another loop, but I'm not sure it is worth it.

I'm pretty sure the code works as it is, since it is the same as the
code in the Android kernel.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
