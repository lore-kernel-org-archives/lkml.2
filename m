Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab0JMGkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 02:40:20 -0400
Received: from kroah.org ([198.145.64.141]:36319 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab0JMGkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 02:40:19 -0400
Date: Tue, 12 Oct 2010 23:40:05 -0700
From: Greg KH <greg@kroah.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: [stable] dm-crypt: plain64 IV support for -stable?
Message-ID: <20101013064005.GA4715@kroah.com>
References: <20101012132511.GA24455@khazad-dum.debian.net> <20101012141143.GA12143@kroah.com> <20101012190438.GB16717@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012190438.GB16717@khazad-dum.debian.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 04:04:38PM -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 12 Oct 2010, Greg KH wrote:
> > Which -stable tree?  .27, .32, .35, or any/all of them?  Please be more
> > specific when asking for this in the future.
> 
> Just 2.6.32.  It is already in 2.6.35, and 2.6.27 is too old for it to
> matter.

Ok.

> > > Without it, users of LTS kernels like 2.6.32 are missing important
> > > functionality (as in: might not be able to mount some LUKS volumes
> > > created on newer kernels).
> > 
> > Also note that this patch really looks like a "new feature", not a
> > bugfix or anything that matches up with what
> > Documentation/stable_kernel_rules.txt defines.  So I don't think that it
> > really is something to add to a stable kernel.
> 
> Using "plain" for IVs on block devices with more than 2^32 blocks will cause
> the same IV to be used twice due to roll-over.  This is not a good thing,
> although it might be not bad enough to matter much (or it could be a
> terrible problem.  Someone who groks crypto for real would have to answer
> that).
> 
> One cannot fix "plain", or data after the roll-over point becomes unreadable
> on any already-existing devices.  Thus, a new IV was added with the fix,
> "plain64".
> 
> Distros will probably need to backport this, as userspace and docs are
> already starting to tell users to use aes-xts-plain64 and not aes-xts-plain.
> They will use them in their portable HDs, and then will not be able to read
> them back in various stable distros.   Might as well do it upstream where it
> will benefit everybody...

If they create them in a newer kernel, and then try to use an older
kernel, how would they normally expect them to work?

Yes, I understand your point, but please note that this is a new feature
being added, which is not what the stable tree is for at all.  If it's a
real issue, let the distros know about it, but even then, I doubt they
will care as they don't support such a "use on new, then on old" type
model either.

thanks,

greg k-h
