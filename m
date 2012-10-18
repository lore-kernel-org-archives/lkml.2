Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2JRJy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:54:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44105 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2JRJy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:54:56 -0400
Date: Thu, 18 Oct 2012 10:59:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeffrey Ladouceur <jladouceur@gmail.com>
Cc: Mark Einon <mark.einon@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: et131x: Fix 64bit tx dma address handling
Message-ID: <20121018105956.2f3ea239@pyramind.ukuu.org.uk>
In-Reply-To: <CAEJO9GS6Q72bSc+FgK29=dASu+E731uL-nFApKw0-tMSjaTsDw@mail.gmail.com>
References: <1350508512-15562-1-git-send-email-mark.einon@gmail.com>
	<1350508512-15562-2-git-send-email-mark.einon@gmail.com>
	<CAEJO9GS6Q72bSc+FgK29=dASu+E731uL-nFApKw0-tMSjaTsDw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +                                                         skb_headlen(skb),
> > +                                                         DMA_TO_DEVICE);
> > +                               desc[frag].addr_lo = dma_addr & 0xFFFFFFFF;
> > +                               desc[frag].addr_hi = dma_addr >> 32;
> 
> Maybe use macros defined in kernel.h instead:
> 
> desc[frag].addr_lo = lower_32_bits(dma_addr);
> desc[frag].addr_hi = upper_32_bits(dma_addr);
> 
> A few more instances below.

This is actually important because >> 32 of a 32bit value is undefined in
C. The compiler is free to do what it likes with this. While the results
are usually sane some architectures do generate the equivalent of

		x >> (n % wordsize);


Alan
