Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0HaUhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 16:37:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab0HaUhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 16:37:22 -0400
Date: Tue, 31 Aug 2010 16:36:58 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Neil Brown <neilb@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100831203658.GC5759@shell>
References: <20100826183340.027591901@szeredi.hu> <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene> <20100830183843.GB2444@shell> <20100831091211.403e0d06@notabene> <E1OqOa5-000677-BN@pomaz-ex.szeredi.hu> <20100831212450.6729ddd7@notabene> <AANLkTimjvRV4ep-RNDgdOPdz77BJ5+4KJr5_UBA6Q9P+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimjvRV4ep-RNDgdOPdz77BJ5+4KJr5_UBA6Q9P+@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 11:05:18AM -0400, Kyle Moffett wrote:
> On Tue, Aug 31, 2010 at 07:24, Neil Brown <neilb@suse.de> wrote:
> > On Tue, 31 Aug 2010 13:00:45 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> No, I don't think this design will do that. ??So it might be enough
> >> just to document that online modification of upper or lower
> >> filesystems results in undefined behavior.
> >>
> >> But to prevent accidental damage, it's prudent (at least by default)
> >> to enforce the no-modification policy.
> >>
> >> Why do you think this feature of allowing modification is important?
> >> Lets take some typical use cases:
> >>
> >> ??- live cd: lower layer is hard r/o, upper layer makes no sense to
> >> ?? ??modify online
> >>
> >> ??- thin client: lower layer is static except upgrades, which need
> >> ?? ??special tools to support and is done offline, upper layer makes no
> >> ?? ??sense to modify online
> >>
> >> Do you have some cases in mind where it makes at least a little sense
> >> to allow online modification of the underlying filesystems?
> >
> > No, I don't have a particular use case in mind that would take advantage of
> > the layers being directly modifiable. ??But I know that sys-admins can be very
> > ingenious and may well come up with something clever.
> >
> > My point is more that I don't think that is it *possible* to prevent changes
> > to the underlying filesystem (NFS being the prime example) so if there are
> > easy steps we can take to make the behaviour of overlayfs more predictable in
> > those cases, we should.
> 
> There's certainly already weird behaviors you can cause by regular
> filesystem over-mounts on NFS.  For example, I have an NFS server that
> exports a "/srv/git" directory; if I was to do the following actions
> on a client:
> 
> # mkdir /srv/git
> # mount -t nfs myserver:/srv/git /srv/git
> # mkdir /srv/git/mnt
> # mount -t ext3 /dev/sda3 /srv/git/mnt
> 
> And then from the server I were to:
> # rmdir /srv/git/mnt
> 
> Terrible terrible things would happen... by which I mean I can no
> longer access or unmount that filesystem from the client.  That use
> case in particular seems to be much worse than your regular unionfs
> example even, and it's easily possible today (even by accident).

While this definitely sucks, the concern in this case with unioning
file systems is a deadlock or kernel panic, not just "weird" behavior
or inability to unmount a file system.  Although in general I like the
standard for union behavior as "not as bad as NFS." :)

-VAL
