Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935052Ab1ETBuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:50:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:34217 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934716Ab1ETBuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:50:18 -0400
Subject: Re: [PATCH 5/7] [RFC] force 32-byte aligned kmallocs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
In-Reply-To: <BANLkTimc3jQTOJdqAiqbPxGQNVWe39VqfQ@mail.gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-5-git-send-email-ericvh@gmail.com>
	 <1305851769.7481.90.camel@pasglop>
	 <BANLkTimc3jQTOJdqAiqbPxGQNVWe39VqfQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 11:50:03 +1000
Message-ID: <1305856203.7481.116.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 19:47 -0500, Eric Van Hensbergen wrote:
> On Thu, May 19, 2011 at 7:36 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Wed, 2011-05-18 at 16:24 -0500, Eric Van Hensbergen wrote:
> >>
> >> -#ifdef CONFIG_NOT_COHERENT_CACHE
> >> +#if defined(CONFIG_NOT_COHERENT_CACHE) || defined(CONFIG_BGP)
> >>  #define ARCH_DMA_MINALIGN    L1_CACHE_BYTES
> >>  #endif
> >
> > Is DMA cache coherent on BG/P ? That's odd for a 4xx base :-)
> >
> 
> My understanding of things (which could be totally wrong) is that the
> DMA we care about on BG/P (namely the Torus and Collective networks)
> is coherent at the L2.  Of course the change in question is talking
> about L1_CACHE_BYTES, so my reading of this is that its a sleazy way
> of getting aligned mallocs that make interactions with the tightly
> coupled networks easier/more-efficient.  I'm open to alternative
> suggestions.

But if it's not coherent with L1, then you sould have
CONFIG_NOT_COHERENT_CACHE set and not need that patch... or am I missing
something ?

One thing we should do some day as well is make that whole non-coherent
be runtime selected, on the list of things to fix 440+47x in the same
kernel. Pfiew....

Cheers,
Ben.

