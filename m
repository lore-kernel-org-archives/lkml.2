Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab0EKUrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:47:53 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54217 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab0EKUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:47:51 -0400
Message-ID: <4BE9C258.10706@cs.helsinki.fi>
Date: Tue, 11 May 2010 23:47:20 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       "=?UTF-8?B?RGFuaWVsIEdsw7Zja25lcg==?=" <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
References: <1273487642-2169-1-git-send-email-os@emlix.com> 	<AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com> 	<20100511063309.GC9644@core.coreip.homeip.net> <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com> 	<AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com> 	<1273608441.15067.1002.camel@calx> <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com> 	<alpine.DEB.2.00.1005111520260.1500@router.home> <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com> 	<4BE9C033.2020106@cs.helsinki.fi> <AANLkTinZe1N2NFOzU32PL2AIZi9TovHj5pQ2Y65eOc1T@mail.gmail.com>
In-Reply-To: <AANLkTinZe1N2NFOzU32PL2AIZi9TovHj5pQ2Y65eOc1T@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Tue, May 11, 2010 at 16:38, Pekka Enberg wrote:
>> Mike Frysinger wrote:
>>> that is a question for David/Grant.  i'm not the SPI core maintainer,
>>> i'm merely watching over some SPI drivers.  however, this answer also
>>> doesnt sound like it's thinking big enough because what you're
>>> proposing isnt specific to the SPI bus -- any time a DMA safe buffer
>>> is needed dynamically, this function could be used.
>> Well, we have dma_alloc_coherent(), shouldn't you be using that instead?
> 
> my understanding is that dma_alloc_coherent() gives you a buffer that
> is always coherent.  the SPI layers take care of flushing and such on
> the fly which means allocating coherent memory is overkill and bad for
> performance.

OK, I'm out of my expert area here but if dma_alloc_coherent() doesn't 
work for you, you should probably extend the DMA API, not kmalloc().

			Pekka
