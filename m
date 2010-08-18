Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0HRILh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:11:37 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56610 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab0HRILd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:11:33 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-reply-to: <20100817214404.GH5556@shell> (message from Valerie Aurora on
	Tue, 17 Aug 2010 17:44:04 -0400)
Subject: Re: [PATCH 19/39] union-mount: Implement union lookup
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-20-git-send-email-vaurora@redhat.com> <E1Ojud6-0004Br-D6@pomaz-ex.szeredi.hu> <20100817214404.GH5556@shell>
Message-Id: <E1Oldjq-0005zf-2m@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 18 Aug 2010 10:11:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Valerie Aurora wrote:
> On Fri, Aug 13, 2010 at 03:49:04PM +0200, Miklos Szeredi wrote:
> > On Sun,  8 Aug 2010, Valerie Aurora wrote:
> > > Implement unioned directories, whiteouts, and fallthrus in pathname
> > > lookup routines.  do_lookup() and lookup_hash() call lookup_union()
> > > after looking up the dentry from the top-level file system.
> > > lookup_union() is centered around __lookup_hash(), which does cached
> > > and/or real lookups and revalidates each dentry in the union stack.
> > > 
> > > XXX - implement negative union cache entries
> > > 
> > > XXX - handle different permissions on directories
> > 
> > If process doing the lookup doesn't have write permission on the top
> > level directory then the lookup will fail.  This is not intended, is
> > it?
> 
> Does it fail?  I'm not checking permissions before calling
> ->fallthru().  But I can't test this because the code doesn't set the
> owner of the copied up directory correctly. :)

It fails because everything, including copyup, is done with the
credentials of the user doing the lookup/copyup.  This is wrong, for
the time of the copyup the credentials need to be upgraded to be able
to create and copy the lower file or directory into the upper
filesystem even when the current process doesn't have enough
privileges for that.

Thanks,
Miklos
