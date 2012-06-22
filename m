Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959Ab2FVBxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 21:53:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760940Ab2FVBxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 21:53:46 -0400
Date: Thu, 21 Jun 2012 18:53:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [PATCH 00/23] Crypto keys and module signing
Message-ID: <20120622015341.GA3414@kroah.com>
References: <8762blyedn.fsf@rustcorp.com.au>
 <87obpfxdpr.fsf@rustcorp.com.au>
 <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
 <7474.1337782847@redhat.com>
 <5107.1337868051@redhat.com>
 <87r4u6w58c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4u6w58c.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 03:11:23PM +0930, Rusty Russell wrote:
> > > > Why would you want multiple signatures?  That just complicates things.
> > > 
> > > The code above stays pretty simple; if the signature fails, you set size
> > > to i, and loop again.  As I said, if you know exactly how you're going
> > > to strip the modules, you can avoid storing the stripped module and
> > > simply append both signatures.
> > 
> > You still haven't justified it.  One of your arguments about rejecting the ELF
> > parsing version was that it was too big for no useful extra value that I could
> > justify.  Supporting multiple signatures adds extra size and complexity for no
> > obvious value.
> 
> One loop is a lot easier to justify that the ELF-parsing mess.  And it
> can be done in a backwards compatible way tomorrow: old kernels will
> only check the last signature.
> 
> I had assumed you'd rather maintain a stable strip util which you can
> use on kernel modules than rework your module builds.  I guess not.

To dig an old thread up, but what really is wrong with the original ELF
section stuff?  Why encode "magic" values on the end of the kernel
module that then require all userspace tools to be modified in order to
properly handle this?

When I first did this so many many years ago an elf section made it so
easy to handle.  Userspace didn't need to be modified, and everyone
knows how to handle elf sections, even the kernel does :)

And I think we really want the ability to have multiple signatures, the
whole "chain of trust" thing that is needed will work out much better if
multiple signatures are allowed.  Putting it in an elf section allows
this to work out easier, right?

confused,

greg k-h
