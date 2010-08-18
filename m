Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0HRTEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:04:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab0HRTEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:04:51 -0400
Date: Wed, 18 Aug 2010 15:04:35 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
Message-ID: <20100818190435.GC10850@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene> <20100817204430.GE5556@shell> <20100818085333.02fa54d4@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818085333.02fa54d4@notabene>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 08:53:33AM +1000, Neil Brown wrote:
> On Tue, 17 Aug 2010 16:44:30 -0400
> Valerie Aurora <vaurora@redhat.com> wrote:
> > 
> > I felt the way you did until I talked to several users who explained
> > to me why none of the existing solutions worked well for their use
> > case.  The real-life use cases are those where people are currently
> > using unionfs and aufs, which include many live CDs, Linux appliances,
> > and at least three national lab computer clusters.  The best argument
> > for their need for a union file system is that they are using unionfs
> > and aufs despite the pain of using out-of-mainline code and (according
> > to the users I have spoken to) frequent crashes.  Union mounts is
> > intended as an in-mainline replacement for the existing users of
> > unionfs and aufs.
> 
> You present a good argument that "something must be done", but it gives no
> pointers to what that something should be.
> I don't suppose it is possible to get that explanation you mention is writing?

Sorry, all the documentation I have about union mounts is publicly
available.  I'll announce any new documentation in the usual way.

If you are willing to do the research personally, you can start with
the list of projects using unionfs:

http://www.fsl.cs.sunysb.edu/project-unionfs.html

> > It is true, you have to know what you are doing and carefully groom
> > both file systems if you want to change the lower file system and get
> > the effect you intended.  Just updating the lower file system and
> > slapping the overlay back on will probably not accomplish what you
> > want.
> > 
> > But frankly, this is an impossible problem to solve generically at the
> > file system level. 
> 
> Absolutely right - no argument about that.
> I just think that should be explicit in the documentation.
> Right after the "Online upgrade" paragraph:
> 
>   Even off-line upgrade - e.g. installing software on an exported filesystem
>   and the remounting that on client and union-mounting a pre-existing over
>   lay on top of it - is significantly non-trivial and would require
>   significant extra management software to created a working solution.
>  (or something like that, but more that just one long sentence).

Okay, I'll put something in the next time I update the docs.

> > > As a counter-position for you or others to write cogent arguments against,
> > > and to then include those arguments in the justification section,  I would
> > > like to present my preferred approach, which is essentially that the problem
> > > is better solved at the block layer or the distro layer.
> > 
> > I personally like the block layer solution better and would be
> > happiest if all unionfs and aufs users switched to it and no one
> > needed union mounts. :) This is one case where the author is not in
> > love with the solution.  I'm not going to argue for the need for it
> > beyond noting the existing unionfs and aufs user base.
> 
> That may be enough justification to work on this as a research project, but I
> don't think it is enough justification to merge it into mainline.
> 
> Just because aufs might be the best available solution to a particular problem
> doesn't mean that making a better aufs (aka VFS union mounts) will be the best
> possible solution.  That can only be determine if the key needs, and the
> problems with all available solutions, are publicly known.

The problems with all available solutions, including union mounts, are
thoroughly documented in my four LWN articles on union mounts:

http://lwn.net/Articles/324291/
http://lwn.net/Articles/325369/
http://lwn.net/Articles/327738/
http://lwn.net/Articles/396020/

I understand your desire for better documentation.  But contrary to
popular conception, I hate writing and do it as seldom as possible. :)

Thanks,

-VAL
