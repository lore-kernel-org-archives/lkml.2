Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2BEQWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 11:22:16 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41427 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2BEQWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 11:22:14 -0500
MIME-Version: 1.0
In-Reply-To: <20120205123415.GY889@n2100.arm.linux.org.uk>
References: <1326959620-25920-1-git-send-email-b32955@freescale.com>
	<1326959620-25920-2-git-send-email-b32955@freescale.com>
	<CAMiH66FoX0m_NPntMRyt6zJoYgxuYnzv6neDggmKxW8nfzKJiA@mail.gmail.com>
	<20120205123415.GY889@n2100.arm.linux.org.uk>
Date: Mon, 6 Feb 2012 00:22:13 +0800
Message-ID: <CAMiH66F+Nz0b=S-=_97MuBgmPz8svG6-9QVZmtTCjg12H6jUng@mail.gmail.com>
Subject: Re: [PATCH resent v2 1/2] ioport : add DEFINE_RES_DMA_SIZE_NAMED macro
From: Huang Shijie <shijie8@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Huang Shijie <b32955@freescale.com>, akpm@linux-foundation.org,
        shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, u.kleine-koenig@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 8:34 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Feb 05, 2012 at 07:53:31PM +0800, Huang Shijie wrote:
>> Does any one have any comments about this patch?
>
> Yes.  Having a flat numberspace for DMAs invites the same problems that
> we have with the flat IRQ numberspace when it comes to having multiple
> DMA controllers.
>
> With DMA engine drivers, channels are allocated using a match function
> and unspecified match data.  While a linear numberspace can be used,
> that sets itself up for clashing between different DMA controllers
> especially if the numberspace overlaps.
>
> What's missing from this patch set is an illustration of how this will
> be used.
>
> Another issue here is that having the peripheral drivers know about the
> exact match function and what data the DMA engines require ties the
> periperal drivers to their respective DMA engine.  One of the points of
> DMA engine is to separate that knowledge, so that the same peripheral IP
> can be re-used with different DMA engines.
>
> To encode knowledge of the DMA engine into the peripheral driver basically
> destroys the purpose of having a DMA engine API.
>
> So, I believe that _if_ we are going down the path of using the DMA engine
> API for our SoCs, we really don't want to invent a linear DMA numberspace
> by putting DMA numbers into resources.

ok. thanks.


Huang Shijie
