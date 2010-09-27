Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab0I0SvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab0I0SvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:51:03 -0400
Date: Mon, 27 Sep 2010 14:50:17 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Ram Pai <ram.n.pai@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/34] VFS: Add CL_NO_SLAVE flag to clone_mnt()/copy_tree()
Message-ID: <20100927185017.GD8089@shell>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com> <1284675145-4391-4-git-send-email-vaurora@redhat.com> <AANLkTim1bbGrrPcFHThx3XOm8GmudQFSmFUs3NAXT5yC@mail.gmail.com> <20100917043401.GD8926@ram-laptop> <20100917171514.GA32258@shell> <20100920052553.GM8926@ram-laptop> <20100921000344.GB9032@shell> <20100927054205.GE4999@ram-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927054205.GE4999@ram-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 10:42:05PM -0700, Ram Pai wrote:
> On Mon, Sep 20, 2010 at 08:03:44PM -0400, Valerie Aurora wrote:
> > On Sun, Sep 19, 2010 at 10:25:53PM -0700, Ram Pai wrote:
> > > 
> > > I understand your intentions, but I think you are making a wrong assumption.
> > > You seem to be thinking that if a slave-mount is cloned, the new cloned
> > > mount will also be a slave-mount and will hence receive propagations. As
> > > per shared subtree semantics, a slave-mount when cloned will create a private
> > > mount. Since your intention is to avoid generating any new mounts that 
> > > recieve propagations, you should be checking for shared-mounts and 
> > > slave-shared-mounts because these are the two kind of mounts that when
> > > cloned create new mounts that receive propagation.
> > 
> > No.  This isn't about the semantics of the clone mount operation.  It
> > is about the administrator creating a slave mount, unioning it, and
> > then being surprised when the unioned file system does not receive
> > mount propagation events.
> > 
> > Think of the source vfsmount tree as a set of command line arguments
> > for the union mount.
> 
> Ok. In that case,  you introduced a subtle change in the semantics of clone_mnt().
> As I understand it, the flags parameter of clone_mnt() are meant to be a modifier 
> for the cloned mount, not a filter on the source mount.

Yes, that's it exactly.

Do you have a suggestion for writing this a different way?  We can
move it all into copy_tree() and leave clone_mnt() alone, at the cost
of a little code duplication and some acrobatics around possible
loopback support.

-VAL
