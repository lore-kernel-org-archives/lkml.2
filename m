Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0HRS4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:56:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0HRS4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:56:02 -0400
Date: Wed, 18 Aug 2010 14:55:42 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
Message-ID: <20100818185542.GA10850@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene> <20100817204430.GE5556@shell> <6820.1282094632@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6820.1282094632@jrobl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 10:23:52AM +0900, J. R. Okajima wrote:
> 
> Valerie Aurora:
> > and at least three national lab computer clusters.  The best argument
> > for their need for a union file system is that they are using unionfs
> > and aufs despite the pain of using out-of-mainline code and (according
> > to the users I have spoken to) frequent crashes.  Union mounts is
> 
> Hmm, anyone who meets crash in aufs, please let me know.
> While I never say aufs is bug-free, I don't receive such report
> recently. I always try fixing a bug as soon as possible when I got a
> report.

According Al Viro, unionfs has some fundamental architectural problems
that prevents it from being correct and leads to crashes:

http://lkml.indiana.edu/hypermail/linux/kernel/0802.0/0839.html

The main question for me is whether aufs has fixed these problems.  If
it hasn't, then it can't be bug-free.

> A reply I have to write repeatedly to who have met a problem in aufs and
> reported to aufs-users ML, is "your aufs version is too old. please get
> the latest one."
> Because aufs is released every week and some linux distributions keep
> using very old aufs version, even over one year old version than thier
> release date.
> 
> By the way, I don't have objection to merge Val's UnionMount into
> mainline as I have heard it is already decided.

I wish I had your confidence. :)

> > But frankly, this is an impossible problem to solve generically at the
> > file system level.  When a user says, "Show the changes to the lower
> > file system in my overlaid file system," they are actually saying,
> 
> Is it (mostly) possible by receiving a notification via fsnotify?
> For remote FS, their ->d_revalidate() will tell us something is changed.

Think about the case of two different RPM package database files.  One
contains the info from newly installed packages on the top layer file
system.  The lower layer contains info from packages newly installed
on the lower file system.  You don't want either file; you want the
merged packaged database showing the info for all packages installed
on both layers.  Any practical file system based system is only going
to be able to pick one file or the other, and it's going to be wrong
in some cases.

-VAL
