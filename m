Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab0EKUzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:55:05 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:61119 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab0EKUzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JvNg66UmHlgxWr/LNNmAFsjEdCIcS1DeTrXPdHHmIfavxxggLyBDZbTiJ8JA75sukk
         ZIJGB+TtnCFALOCyrlV1dn0mMUjlLwqi5yFI3xC5J5VQTwCL6c6Y8sKo7/i0GTSnvAwb
         3utNnQcrUZIsOIvLC9P/+m+GJXEDaGfBAbS1c=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1005111544330.8388@router.home>
References: <1273487642-2169-1-git-send-email-os@emlix.com> 
	<AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com> 
	<20100511063309.GC9644@core.coreip.homeip.net> <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com> 
	<AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com> 
	<1273608441.15067.1002.camel@calx> <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com> 
	<alpine.DEB.2.00.1005111520260.1500@router.home> <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com> 
	<alpine.DEB.2.00.1005111544330.8388@router.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 May 2010 16:54:41 -0400
Message-ID: <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 16:46, Christoph Lameter wrote:
> On Tue, 11 May 2010, Mike Frysinger wrote:
>> > DMA. If the arch can only DMA into cacheline aligned objects then the
>> > correct method is to force kmalloc alignment to cacheline size.
>>
>> these are SPI drivers and are usable on any arch that supports a SPI
>> bus (which is pretty much every arch).  forget about "embedded"
>> arches.
>>
>> the issue here is simple: a SPI driver (AD7877) needs to do a receive
>> SPI transfer into a DMA safe buffer.  what is the exact API to
>> dynamically allocate memory for the structure with this buffer
>> embedded in it such that the start of the structure is cached aligned
>> ?  creating a dedicated kmem cache may work, but it isnt a scalable
>> solution if every SPI driver needs to create its own cache.
>
> kmalloc returns a pointer to a DMA safe buffer. There is no requirement on
> the x86 hardware that the DMA buffers have to be cache aligned. Cachelines
> will be invalidated as needed.

so this guarantee is made by the kmalloc() API ?  and for arches where
the cacheline invalidation is handled in software rather than
hardware, they must declare a min alignment value for kmalloc to be at
least as big as their cache alignment ?

does the phrase "DMA safe buffer" imply cache alignment ?
-mike
