Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1LZBsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 20:48:05 -0500
Received: from iabervon.org ([66.92.72.58]:40328 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab1LZBr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 20:47:56 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Dec 2011 20:47:56 EST
Date: Sun, 25 Dec 2011 20:41:14 -0500 (EST)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Willy Tarreau <w@1wt.eu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition
 devices
In-Reply-To: <20111223062649.GD21994@1wt.eu>
Message-ID: <alpine.LNX.2.00.1112252025490.2056@iabervon.org>
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com> <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com> <4EF391A6.2040504@redhat.com>
 <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com> <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com> <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com>
 <20111223062649.GD21994@1wt.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011, Willy Tarreau wrote:

> On Thu, Dec 22, 2011 at 04:07:46PM -0800, Linus Torvalds wrote:
> > For example, I just traced it, and "eject /dev/sdb1" does a CDROMEJECT
> > ioctl when used as the root user. I haven't tested the patch, but just
> > reading it, I'd expect it to break that.
> > 
> > And that's the *natural* way to eject a mounted device. Look at the
> > USB memory sticks you have. They are almost all partitioned to have
> > one partition, and that one partition doesn't cover the whole device.
> > And it's that one partition you use to interact with it - it's what
> > you mount, and what you eject.
> 
> Call me dumb, but why would someone use "eject" on a non-physically
> ejectable device such as a memory stick ? I use it on CDs, I've used
> it on Sun floppy drives, but USB memory stick ??? After the umount,
> I just have to pull it from the plug and that's all. I don't catch
> what an eject command can bring me on top of that :-/

I use "eject" on my (old) ipod in order to get it to stop telling me not 
to unplug it. The device doesn't actually have any problems if it just 
gets yanked while it's neither mounted nor ejected, but it acts unhappy 
through its UI, since it doesn't know the computer's state. (And I pass 
"eject" the mountpoint, because that's short and tab-completes and 
"eject" translates the mountpoint into a device node with fstab so it 
works.)

	-Daniel
*This .sig left intentionally blank*
