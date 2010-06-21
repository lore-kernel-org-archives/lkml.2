Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0FUN1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:27:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab0FUN1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:27:03 -0400
Date: Mon, 21 Jun 2010 09:26:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100621132655.GF3217@redhat.com>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
 <20100619103056.194fb221@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619103056.194fb221@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 10:30:56AM +0100, Alan Cox wrote:
> > Typically, one would push a config patch to enable and disable the feature and
> > patch the distribution.  However, in some cases this is not feasible in order
> 
> If you can push a patch to set the flag you can push a patch to panic or
> reject that combination.

We could, but we didn't think mainline would interested in restricting
what they support based on RHEL's needs.  Also we still wanted to retain
the ability to use a piece of hardware even though we do not officially
support it, thus we were trying to avoid the panic and just set a flag
instead.

> 
> Devil's advocate time: 
> 
> Also the fact some distributions chose a binary compatible interface for
> their internal modules was their choice. It is one that has been
> repeatedly rejected by upstream and at kernel summit.
> 
> So given we fundamnetally reject your approach why should we carry your
> flag ?

I'm confused, this has nothing to do with KABI.  It is just a flag that
something like the installer or a system report could look at to inform
users they are running on a system that may not be supported.

Again, we thought this might be useful for other distros as well who want
to make it easier to filter through bugzillas as close out bugs that has
this flag set.

> 
> > In some cases the distribution may want to allow booting of these features but
> > explicitly notify a user that they are not "officially" supported.  It is also
> 
> We have printk. You can add a module of your own which indicates
> 'support' status too.

> 
> > possible that the hardware is fixed via a firmware update at a later date,
> > making it supported again.
> 
> IMHO it's not properly named in the first place. You are talking about
> combinations of hardware/firmware and you actually mean 'configuration
> not supported' ?

Mainly hardware platforms that do not necessarily have a config option
wrapped around them.

> 
> > This patch introduces the TAINT_HARDWARE_UNSUPPORTED flag for distributions
> > to use.
> 
> and why KERN_CRIT when the other printk's don't use that level ?

The thinking was that we wanted to make sure the end user saw the
message, but we can set it to any level really.

> 
> A suggestion: instead of all this push a single patch with a comment and
> maybe defines indicating that taint flag bits 28-31 are 'reserved' for
> experimental and out of tree applications.
> 
> That way anyone who has a requirement like yours can deal with it and
> nobody has to worry about bit collisions, naming and the like. Nor if you
> suddenely need an extra bit in 3 years time are you going to come unstuck
> on your KABI. That will help other people doing experiments with taint or
> with differing needs to the Red Hat one.

That seems like a reasonable request and basically covers one of the
reasons for pushing this patch.

Thanks for the review.

Cheers,
Don
