Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0KXTAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:00:14 -0500
Received: from relais.videotron.ca ([24.201.245.36]:43993 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0KXTAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:00:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 24 Nov 2010 14:00:12 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: James Jones <jajones@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix find_next_zero_bit and related assembly
In-reply-to: <4CED55A6.5090608@codeaurora.org>
Message-id: <alpine.LFD.2.00.1011241357520.9313@xanadu.home>
References: <1289524615-22484-1-git-send-email-jajones@nvidia.com>
 <alpine.LFD.2.00.1011231625380.9313@xanadu.home>
 <201011231528.25668.jajones@nvidia.com> <4CED55A6.5090608@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Nov 2010, Stephen Boyd wrote:

> On 11/23/2010 03:28 PM, James Jones wrote:
> > On Tuesday 23 November 2010 13:26:47 Nicolas Pitre wrote:
> >> On Thu, 11 Nov 2010, James Jones wrote:
> >>> The find_next_bit, find_first_bit, find_next_zero_bit
> >>> and find_first_zero_bit functions were not properly
> >>> clamping to the maxbit argument at the bit level. They
> >>> were instead only checking maxbit at the byte level.
> >>> To fix this, add a compare and a conditional move
> >>> instruction to the end of the common bit-within-the-
> >>> byte code used by all the functions and be sure not to
> >>> clobber the maxbit argument before it is used.
> >>>
> >>> Signed-off-by: James Jones <jajones@nvidia.com>
> >>> Tested-by: Stephen Warren <swarren@nvidia.com>
> >> Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> >>
> >> Please send to RMK's patch system.
> > Thanks for the review.  It's already in the patch system, but I updated the 
> > entry to include your reviewed-by line.
> 
> Should this be sent to the stable tree too?

It could, yes.  This is hardly an urgent fix though, as the bug has been 
there virtually forever.


Nicolas
