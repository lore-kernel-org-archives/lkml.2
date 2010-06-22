Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab0FVNLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:11:33 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39132 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758389Ab0FVNLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:11:31 -0400
X-Sasl-enc: WxyyEb2YiEW0L6A4epkH6TVyobj3BdMk2+PEe/lEGBkp 1277212289
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount
 in super block info
From: Ian Kent <raven@themaw.net>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       vaurora@redhat.com, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, jblunck@suse.de
In-Reply-To: <26799.1277185756@jrobl>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	 <1276627208-17242-5-git-send-email-vaurora@redhat.com>
	 <1276661043.2339.35.camel@localhost> <1277091579.3827.9.camel@localhost>
	 <E1OQghj-0001Bt-RU@pomaz-ex.szeredi.hu> <1277181999.2829.2.camel@localhost>
	 <26799.1277185756@jrobl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 21:11:23 +0800
Message-ID: <1277212283.2829.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 14:49 +0900, J. R. Okajima wrote:
> Ian Kent:
> > +static vfsmount *autofs4_find_vfsmount(struct path *parent, struct dentry *root)
> > +{
> > +	struct vfsmount *mnt = NULL;
> > +	struct dentry *child;
> > +
> > +	spin_lock(&dcache_lock);
> > +	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
> 
> dentry->d_subdirs?
> parent->dentry->...?

Yep, thanks, cut and paste error.

Like I said, I don't want to go though the test process unless I have
something that is, in principal, OK.

If whatever approach we use is acceptable, and will work, then I'll put
the effort into it. I just don' want to spend a heap of time on
something that is basically not the right thing to do. For example,
exporting lookup_mnt?

> 
> Or how about iterate_mounts() instead of loop over dentries?
> For example (just a example),
> 
> struct args {
> 	/* input */
> 	struct dentry *root;
> 
> 	/* output */
> 	struct vfsmount *mnt;
> };
> 
> static int compare_mnt(struct vfsmount *mnt, void *arg)
> {
> 	struct args *a = arg;
> 
> 	if (mnt->mnt_root != a->root)
> 		return 0;
> 	a->mnt = mntget(mnt);
> 	return 1;
> }
> 
> struct vfsmount *autofs4_find_vfsmount(struct dentry *root)
> {
> 	int err;
> 	struct args args = {
> 		.root = root
> 	};
> 
> 	err = iterate_mounts(compare_mnt, &args, current->nsproxy->mnt_ns);
> }

Oh, I'm not up with this, I'll have to check this out, might be useful
for more than just this case, thanks for the comments.

Ian


