Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0JAAdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:33:51 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60315 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0JAAdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:33:49 -0400
Date: Thu, 30 Sep 2010 17:33:42 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        hch@infradead.org, agruen@suse.de, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/34] VFS: Make clone_mnt() and copy_tree() return
 error codes
Message-ID: <20101001003342.GI9247@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
 <1284675145-4391-2-git-send-email-vaurora@redhat.com>
 <E1P1FnW-0001yC-Ts@pomaz-ex.szeredi.hu>
 <20100930214123.GA490@shell>
 <20100930214418.GB490@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930214418.GB490@shell>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 05:44:18PM -0400, Valerie Aurora wrote:
> (Resend with correct email for Ram Pai)
> 
> On Thu, Sep 30, 2010 at 11:51:30AM +0200, Miklos Szeredi wrote:
> > On Thu, 16 Sep 2010, Valerie Aurora wrote:
> > > copy_tree() can theoretically fail in a case other than ENOMEM, but
> > > always returns NULL which is interpreted by callers as -ENOMEM.
> > > Convert to return an explicit error.  Convert clone_mnt() for
> > > consistency and because union mounts will add new error cases.
> > 
> > I think it makes sense to push this fix to 2.6.37 independently of the
> > other patches.
> > 
> > Acked-by: Miklos Szeredi <mszeredi@suse.cz>
> 
> I'm certainly not going to argue, but I spent an hour trying to
> trigger the non-ENOMEM case (below) and failed - maybe it's
> unreachable?
> 
> > > @@ -1212,11 +1216,12 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> > >  	struct path path;
> > >  
> > >  	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
> > > -		return NULL;
> > > +		return ERR_PTR(-EINVAL);
> 
> Ram, do you remember how this worked?

Oops. That should be a OR condition. there is one other check in that
function that should also be a OR condition.

BTW: the return value has to be NULL. right? because its not an error
to clone a unbindable mount. Nor is it an error to not specify CL_COPY_ALL.
It just means that you want nothing in return.

RP
