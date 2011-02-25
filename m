Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab1BYUlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:41:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:19154 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790Ab1BYUlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:41:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=FckU+pm3niJMKY/ns5gssVrArMqDfcMO4t8cTIAtJpTWNdBk7CrK2s+ggwvDTlwn89
         bmXQYZVzCI5epfT2l8Sg==
Date: Fri, 25 Feb 2011 12:40:43 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Greg KH <greg@kroah.com>
cc: Dan Carpenter <error27@gmail.com>, Greg KH <gregkh@suse.de>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging
 interfaces
In-Reply-To: <20110225195657.GA8860@kroah.com>
Message-ID: <alpine.LSU.2.00.1102251225150.3918@sister.anvils>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com> <1298398198-18482-2-git-send-email-kees.cook@canonical.com> <20110222181613.GU4000@outflux.net> <20110222191333.GA9991@suse.de> <20110222192248.GX4000@outflux.net> <20110222193314.GA11033@suse.de>
 <20110222202915.GC1966@bicker> <20110225195657.GA8860@kroah.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Greg KH wrote:
> On Tue, Feb 22, 2011 at 11:29:15PM +0300, Dan Carpenter wrote:
> > On Tue, Feb 22, 2011 at 11:33:14AM -0800, Greg KH wrote:
> > > Again, let's fix the real problems here, world-writable debugfs files.
> > 
> > We could just ban them?
> > 
> > diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> > index e7a7a2f..03ae095 100644
> > --- a/fs/debugfs/inode.c
> > +++ b/fs/debugfs/inode.c
> > @@ -223,6 +223,9 @@ struct dentry *debugfs_create_file(const char *name, mode_t mode,
> >  
> >  	pr_debug("debugfs: creating file '%s'\n",name);
> >  
> > +	/* don't allow world writable files */
> > +	mode &= ~S_IWOTH;
> > +
> >  	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
> >  			      &debugfs_mount_count);
> >  	if (error)
> > 
> 
> I have no objection to this patch, care to resend it with a
> signed-off-by: so that I can apply it?

That's funny, I wrote something in debugfs a few months ago which was
very deliberately rw--w--w-: a kind of circular trace buffer into which
any userspace could easily echo its progress for debugging.

Probably won't be upstreamed in that form, nor use debugfs if it is.
But I mention it as an example of why any such limitation on debugfs
seems inappropriate to me.

Hugh
