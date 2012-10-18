Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2JRKR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:17:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64698 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab2JRKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:17:57 -0400
Date: Thu, 18 Oct 2012 11:17:52 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jeffrey Ladouceur <jladouceur@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: et131x: Fix 64bit tx dma address handling
Message-ID: <20121018101741.GA4503@mark-lap>
References: <1350508512-15562-1-git-send-email-mark.einon@gmail.com>
 <1350508512-15562-2-git-send-email-mark.einon@gmail.com>
 <CAEJO9GS6Q72bSc+FgK29=dASu+E731uL-nFApKw0-tMSjaTsDw@mail.gmail.com>
 <20121018105956.2f3ea239@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018105956.2f3ea239@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 10:59:56AM +0100, Alan Cox wrote:
> > > +                                                         skb_headlen(skb),
> > > +                                                         DMA_TO_DEVICE);
> > > +                               desc[frag].addr_lo = dma_addr & 0xFFFFFFFF;
> > > +                               desc[frag].addr_hi = dma_addr >> 32;
> > 
> > Maybe use macros defined in kernel.h instead:
> > 
> > desc[frag].addr_lo = lower_32_bits(dma_addr);
> > desc[frag].addr_hi = upper_32_bits(dma_addr);
> > 
> > A few more instances below.
> 
> This is actually important because >> 32 of a 32bit value is undefined in
> C. The compiler is free to do what it likes with this. While the results
> are usually sane some architectures do generate the equivalent of
> 
> 		x >> (n % wordsize);
> 
> Alan

Thanks for the comments both. I'll send an updated patch this evening.

The intention is to eventually store this value as a dma_addr_t anyway,
but some more work needs to be done to copy the address correctly to the
desc ring.

Cheers,

Mark
