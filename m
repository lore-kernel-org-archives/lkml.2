Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0EMGWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:22:33 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59769 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab0EMGWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:22:31 -0400
Date: Thu, 13 May 2010 15:21:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Christoph Lameter <cl@linux.com>,
       Matt Mackall <mpm@selenic.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Gl??ckner <dg@emlix.com>, Oliver Schneidewind <osw@emlix.com>,
       Johannes Weiner <jw@emlix.com>, Nick Piggin <npiggin@suse.de>,
       David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
Message-ID: <20100513062143.GB9920@linux-sh.org>
References: <20100511063309.GC9644@core.coreip.homeip.net> <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com> <AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com> <1273608441.15067.1002.camel@calx> <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com> <alpine.DEB.2.00.1005111520260.1500@router.home> <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com> <4BE9C033.2020106@cs.helsinki.fi> <AANLkTinZe1N2NFOzU32PL2AIZi9TovHj5pQ2Y65eOc1T@mail.gmail.com> <4BE9C258.10706@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE9C258.10706@cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 11:47:20PM +0300, Pekka Enberg wrote:
> Mike Frysinger wrote:
> >On Tue, May 11, 2010 at 16:38, Pekka Enberg wrote:
> >>Mike Frysinger wrote:
> >>>that is a question for David/Grant.  i'm not the SPI core maintainer,
> >>>i'm merely watching over some SPI drivers.  however, this answer also
> >>>doesnt sound like it's thinking big enough because what you're
> >>>proposing isnt specific to the SPI bus -- any time a DMA safe buffer
> >>>is needed dynamically, this function could be used.
> >>Well, we have dma_alloc_coherent(), shouldn't you be using that instead?
> >
> >my understanding is that dma_alloc_coherent() gives you a buffer that
> >is always coherent.  the SPI layers take care of flushing and such on
> >the fly which means allocating coherent memory is overkill and bad for
> >performance.
> 
> OK, I'm out of my expert area here but if dma_alloc_coherent() doesn't 
> work for you, you should probably extend the DMA API, not kmalloc().
> 
Note that the DMA API already has dma_alloc_noncoherent() for these
sorts of cases. If the driver is taking care of cache maintenance then
dma_alloc_noncoherent() is certainly a reasonable way to go.

Most architectures today simply wrap dma_alloc_noncoherent() to
dma_alloc_coherent(), but if there were more users of the API then
that would quickly change.
