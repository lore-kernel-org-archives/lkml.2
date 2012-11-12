Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2KLXLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:11:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41236 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2KLXLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:11:40 -0500
Date: Mon, 12 Nov 2012 23:08:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Clark <rob.clark@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ARM: add get_user() support for 8 byte types
Message-ID: <20121112230819.GC28341@n2100.arm.linux.org.uk>
References: <1352495853-9790-1-git-send-email-rob.clark@linaro.org> <20121112192727.GB28341@n2100.arm.linux.org.uk> <CAF6AEGu4L+ukxhMBLYK3d2g4CBBXi6o5nN_wXvakZCT8qMfSEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGu4L+ukxhMBLYK3d2g4CBBXi6o5nN_wXvakZCT8qMfSEA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 01:58:32PM -0600, Rob Clark wrote:
> On Mon, Nov 12, 2012 at 1:27 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Nov 09, 2012 at 03:17:33PM -0600, Rob Clark wrote:
> >> From: Rob Clark <rob@ti.com>
> >>
> >> A new atomic modeset/pageflip ioctl being developed in DRM requires
> >> get_user() to work for 64bit types (in addition to just put_user()).
> >
> > NAK.
> >
> > (I did write a better email explaining all the ins and outs of why this
> > won't work and why 64-bit get_user isn't possible, but my editor crapped
> > out and lost all that well written message; I don't fancy typing it all
> > out again.)
> >
> > Nevertheless,
> > int test_ptr(unsigned int **v, unsigned int **p)
> > {
> >         return get_user(*v, p);
> > }
> >
> > produces a warning, and you can't get away from that if you stick 64-bit
> > support into get_user().
> 
> Actually, it seems like using 'register typeof(x) __r2 asm("r2");'
> does avoid that warning..

That seems to pass the checks I've done on it so far, and seems rather
obvious (there's been a number of people looking at this, none of whom
have come up with that solution).  Provided the final cast is kept
(which is there to ensure proper typechecking), it seems like it might
be a solution.
