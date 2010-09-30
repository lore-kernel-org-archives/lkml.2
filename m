Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0I3Voj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 17:44:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab0I3Voi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:44:38 -0400
Date: Thu, 30 Sep 2010 17:44:18 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Ram Pai <linuxram@us.ibm.com>
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
        npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/34] VFS: Make clone_mnt() and copy_tree() return error codes
Message-ID: <20100930214418.GB490@shell>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com> <1284675145-4391-2-git-send-email-vaurora@redhat.com> <E1P1FnW-0001yC-Ts@pomaz-ex.szeredi.hu> <20100930214123.GA490@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930214123.GA490@shell>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resend with correct email for Ram Pai)

On Thu, Sep 30, 2010 at 11:51:30AM +0200, Miklos Szeredi wrote:
> On Thu, 16 Sep 2010, Valerie Aurora wrote:
> > copy_tree() can theoretically fail in a case other than ENOMEM, but
> > always returns NULL which is interpreted by callers as -ENOMEM.
> > Convert to return an explicit error.  Convert clone_mnt() for
> > consistency and because union mounts will add new error cases.
> 
> I think it makes sense to push this fix to 2.6.37 independently of the
> other patches.
> 
> Acked-by: Miklos Szeredi <mszeredi@suse.cz>
 
I'm certainly not going to argue, but I spent an hour trying to
trigger the non-ENOMEM case (below) and failed - maybe it's
unreachable?

> > @@ -1212,11 +1216,12 @@ struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
> >  	struct path path;
> >  
> >  	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
> > -		return NULL;
> > +		return ERR_PTR(-EINVAL);

Ram, do you remember how this worked?

-VAL
