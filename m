Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0GHPrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:47:04 -0400
Received: from kroah.org ([198.145.64.141]:59348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab0GHPrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:47:02 -0400
Date: Thu, 8 Jul 2010 08:46:48 -0700
From: Greg KH <greg@kroah.com>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: BUG: Securityfs and bind mounts (2.6.34)
Message-ID: <20100708154648.GA13923@kroah.com>
References: <201007081112.41252.tvrtko.ursulin@sophos.com>
 <201007081555.01242.tvrtko.ursulin@sophos.com>
 <20100708152059.GA12932@kroah.com>
 <201007081632.42069.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007081632.42069.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 04:32:42PM +0100, Tvrtko Ursulin wrote:
> On Thursday 08 Jul 2010 16:20:59 Greg KH wrote:
> > > :) Well I do not know, but, it kind of smelled like a bug in the
> > > : vfs/mount
> > >
> > > handling/securityfs area so I thought to let experts know. I _think_ I
> > > did nothing that much wrong. Just used the exposed API
> > > (securityfs_remove) and some bind mount shuffling from userspace.
> >
> > securitfs just uses libfs underneath it, and really doesn't have any
> > bindings for module ownerships, so I wouldn't recommend doing what you
> > just did.
> 
> Just do double check what you are saying, securityfs is not safe for use from
> modules? If so I would then recommend removing the exports otherwise it is an
> invitation to shoot yourself into the foot.

Hm, did you properly set the module owner of the file_operations that
you passed to securityfs?  That should protect if you have an open file,
but I doubt anyone thought you would do crazy things like bind mounts on
top of a ramfs and then think it was safe to unload a lower module :)

> Also, in-three TPM driver can be built as a module so how does that
> work?

You have to be root to unload modules, and if you are that, you can do
worse things than this.

thanks,

greg k-h
