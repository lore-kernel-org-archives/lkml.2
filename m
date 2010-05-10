Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab0EJUy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:54:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62720 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab0EJUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ljB745DwF4MN+z5wJXqZOCSU2XY9VF9ZA1KM1ZjmL9IkykSRlWUhteHe5L3SgsS7oJ
         MO5yXsRVh1mBvzgG4S5wk79PnvD3TDUsvX4iBcQYdoHiwuIMizH2TPT0ffbS6o4QbqIq
         8qIGL36EU4EV4bU+ZlSd863TbKaOikpGDxDo8=
Date: Mon, 10 May 2010 13:54:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
Message-ID: <20100510205416.GB30878@core.coreip.homeip.net>
References: <1273487642-2169-1-git-send-email-os@emlix.com>
 <1273488154-2993-1-git-send-email-os@emlix.com>
 <AANLkTiniq9gT5-x8tP3SRXvMvTAZ3VJF7pe21OLl1qDH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiniq9gT5-x8tP3SRXvMvTAZ3VJF7pe21OLl1qDH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:39:49PM -0400, Mike Frysinger wrote:
> On Mon, May 10, 2010 at 06:42, Oskar Schirmer wrote:
> > With dma based spi transmission, data corruption
> > is observed occasionally. With dma buffers located
> > right next to msg and xfer fields, cache lines
> > correctly flushed in preparation for dma usage
> > may be polluted again when writing to fields
> > in the same cache line.
> >
> > Make sure cache fields used with dma do not
> > share cache lines with fields changed during
> > dma handling. As both fields are part of a
> > struct that is allocated via kzalloc, thus
> > cache aligned, moving the fields to the 1st
> > position and insert padding for alignment
> > does the job.
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> 
> i'm guessing Dmitry will pick it up now

Yep.

-- 
Dmitry
