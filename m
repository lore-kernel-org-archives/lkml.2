Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab0EKUvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:51:16 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:55171 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab0EKUvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:51:09 -0400
Date: Tue, 11 May 2010 15:46:59 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
In-Reply-To: <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1005111544330.8388@router.home>
References: <1273487642-2169-1-git-send-email-os@emlix.com>  <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com>  <20100511062110.GB9644@core.coreip.homeip.net> <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com> 
 <20100511063309.GC9644@core.coreip.homeip.net> <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>  <AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com>  <1273608441.15067.1002.camel@calx> <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
  <alpine.DEB.2.00.1005111520260.1500@router.home> <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Mike Frysinger wrote:

> > DMA. If the arch can only DMA into cacheline aligned objects then the
> > correct method is to force kmalloc alignment to cacheline size.
>
> these are SPI drivers and are usable on any arch that supports a SPI
> bus (which is pretty much every arch).  forget about "embedded"
> arches.
>
> the issue here is simple: a SPI driver (AD7877) needs to do a receive
> SPI transfer into a DMA safe buffer.  what is the exact API to
> dynamically allocate memory for the structure with this buffer
> embedded in it such that the start of the structure is cached aligned
> ?  creating a dedicated kmem cache may work, but it isnt a scalable
> solution if every SPI driver needs to create its own cache.

kmalloc returns a pointer to a DMA safe buffer. There is no requirement on
the x86 hardware that the DMA buffers have to be cache aligned. Cachelines
will be invalidated as needed.


