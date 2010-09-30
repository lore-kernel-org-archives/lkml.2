Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab0I3Vv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 17:51:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505Ab0I3Vv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:51:28 -0400
Date: Thu, 30 Sep 2010 17:51:15 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linuxram@us.ibm.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
Message-ID: <20100930215114.GD490@shell>
References: <20100920180404.939991832@szeredi.hu> <E1P08oT-0004C7-3O@pomaz-ex.szeredi.hu> <20100927184747.GC8089@shell> <201009281025.00727.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009281025.00727.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 10:24:59AM +0200, Andreas Gruenbacher wrote:
> On Monday 27 September 2010 20:47:47 Valerie Aurora wrote:
> > Maybe I don't understand.  It seems like directories created when the
> > file system is *not* union mounted should definitely be merged with
> > matching directories on the lower layer.
> >
> > Take the case of /etc/fstab.  The first union mount never touches /etc
> > and it doesn't exist on the topmost layer.  Then we unmount the upper
> > layer, mount it somewhere else as a plain mount, and create /etc/ and
> > /etc/fstab.  When we union mount it back over the lower layer again,
> > we still want the lower layer /etc/ to be merged with the topmost
> > /etc/, or else init.d will disappear.
> 
> I can't think of a reason why the upper layer would really *need* to be 
> modified separately as in this example though, and I'm sure that examples for 
> opaqueness by default can be constructed as well.  Transparency comes at a 
> cost though (lookup, readdir, whiteouts), and defaulting to opaque directories 
> will be more efficient in some cases.  This is why I think that opaqueness by 
> default is preferable.

I agree with that for directories created while it is union mounted.

> > Again, maybe I'm misunderstanding, but this doesn't make much sense to
> > me.  Say I create:
> > 
> > /upper/a_dir/upper_file
> > /lower/a_dir/lower_file
> > 
> > Then when I union mount them, I want a_dir/ to be transparent
> > automatically and show both upper_file and lower_file, without marking
> > it manually.
> 
> Why?

Hm, this was a pretty basic assumption for me - that you'd want to
construct a topmost image offline that would be "merged" with the
lower layers.  So, for example:

Topmost layer contains:

/etc/hostname

Lower layers contain everything else in /etc/.  So /etc/ would exist
on the topmost layer at the time of union mount, but we would want it
to be transparent.  But if we created a new dir *during* the union
mount, it would be opaque.

What was your model?

-VAL
