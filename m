Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab0EKUH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:07:26 -0400
Received: from waste.org ([173.11.57.241]:56366 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361Ab0EKUHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:07:24 -0400
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
From: Matt Mackall <mpm@selenic.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>
In-Reply-To: <AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com>
References: <1273487642-2169-1-git-send-email-os@emlix.com>
	 <1273488154-2993-1-git-send-email-os@emlix.com>
	 <20100510142225.4bf215ef.akpm@linux-foundation.org>
	 <20100511060547.GA9644@core.coreip.homeip.net>
	 <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com>
	 <20100511062110.GB9644@core.coreip.homeip.net>
	 <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com>
	 <20100511063309.GC9644@core.coreip.homeip.net>
	 <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
	 <AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 15:07:21 -0500
Message-ID: <1273608441.15067.1002.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 16:03 -0400, Mike Frysinger wrote:
> On Tue, May 11, 2010 at 02:42, Pekka Enberg wrote:
> > On Tue, May 11, 2010 at 9:33 AM, Dmitry Torokhov wrote:
> >>> what guarantee exactly do you have for that statement ?
> >>
> >> The data is kmalloced, kmalloc aligns on cacheline boundary AFAIK which
> >> means that next kmalloc data chunk will not share "our" cacheline.
> >
> > No, there are no such guarantees. kmalloc() aligns on
> > ARCH_KMALLOC_MINALIGN or ARCH_SLAB_MINALIGN depending on which is
> > bigger but beyond that, there are no guarantees. You can, of course,
> > use kmem_cache_create() with SLAB_HWCACHE_ALIGN to align on cacheline
> > boundary.
> 
> so how is this to be addressed in general ?  this is a problem for any
> device that does SPI transactions, and having every driver create its
> own kmem cache isnt the answer.
> 
> do people need to kmalloc() like 2x the desired size and manually
> align it themselves ?  declaring alignments on struct members doesnt
> matter if the base of the struct isnt aligned.  seems like we need a
> new GFP flag that says we need a cache aligned pointer so we can give
> that to kmalloc() and such.

Make your own slab cache with the alignment flag set, as Pekka already
mentioned.

-- 
Mathematics is the supreme nostalgia of our time.


