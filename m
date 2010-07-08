Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab0GHPXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:23:25 -0400
Received: from kroah.org ([198.145.64.141]:49586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab0GHPXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:23:24 -0400
Date: Thu, 8 Jul 2010 08:20:59 -0700
From: Greg KH <greg@kroah.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG: Securityfs and bind mounts (2.6.34)
Message-ID: <20100708152059.GA12932@kroah.com>
References: <201007081112.41252.tvrtko.ursulin@sophos.com>
 <20100708144317.GA2364@kroah.com>
 <201007081555.01242.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007081555.01242.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 03:55:01PM +0100, Tvrtko Ursulin wrote:
> On Thursday 08 Jul 2010 15:43:17 Greg KH wrote:
> > On Thu, Jul 08, 2010 at 11:12:41AM +0100, Tvrtko Ursulin wrote:
> > > Hi guys,
> > >
> > > If I overlay a file in securityfs using mount --bind with a file from
> > > a regular filesystem, should I be allowed to rmmod the module which
> > > registered the overlaid securityfs file?
> >
> > Why would you want to overlay securityfs in the first place?
> 
> For testing, more precisely faking some data exposed in securityfs module in
> order to provoke userspace reaction. It was convenient to leave the majority
> of real data and just overlay one file.
> 
> > And you might be able to rmmod the module, but I didn't think that
> > security modules were able to be unloaded anymore.
> 
> Perhaps it is not a security module in the way you think about it, just a
> module which happens to register some directories and files under securityfs.

Ick, don't do that then :)

> > > I was able to do that, then I
> > > unmounted the bind mount, and then when attempting to unmount
> > > securityfs hit a BUG at
> > > fs/dcache.c:676 (see below). It would have made more sense to first
> > > umount the overlay file and then remove the module which registered
> > > with securityfs, nevertheless should kernel crash in this case?
> >
> > Probably not, but then again, you did something that you shouldn't have,
> > so perhaps it is telling you not to do such a thing in the future :)
> 
> :) Well I do not know, but, it kind of smelled like a bug in the vfs/mount
> handling/securityfs area so I thought to let experts know. I _think_ I did
> nothing that much wrong. Just used the exposed API (securityfs_remove) and
> some bind mount shuffling from userspace.

securitfs just uses libfs underneath it, and really doesn't have any
bindings for module ownerships, so I wouldn't recommend doing what you
just did.

thanks,

greg k-h
