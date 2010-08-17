Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab0HQVo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:44:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab0HQVoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:44:23 -0400
Date: Tue, 17 Aug 2010 17:44:04 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 19/39] union-mount: Implement union lookup
Message-ID: <20100817214404.GH5556@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-20-git-send-email-vaurora@redhat.com> <E1Ojud6-0004Br-D6@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ojud6-0004Br-D6@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 03:49:04PM +0200, Miklos Szeredi wrote:
> On Sun,  8 Aug 2010, Valerie Aurora wrote:
> > Implement unioned directories, whiteouts, and fallthrus in pathname
> > lookup routines.  do_lookup() and lookup_hash() call lookup_union()
> > after looking up the dentry from the top-level file system.
> > lookup_union() is centered around __lookup_hash(), which does cached
> > and/or real lookups and revalidates each dentry in the union stack.
> > 
> > XXX - implement negative union cache entries
> > 
> > XXX - handle different permissions on directories
> 
> If process doing the lookup doesn't have write permission on the top
> level directory then the lookup will fail.  This is not intended, is
> it?

Does it fail?  I'm not checking permissions before calling
->fallthru().  But I can't test this because the code doesn't set the
owner of the copied up directory correctly. :)

Don't bother doing any permission testing on this version - it's known
buggy and I will fix it in the next release.

Thanks,

-VAL
