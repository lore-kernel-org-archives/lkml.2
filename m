Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1KHNa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 08:30:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab1KHNa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 08:30:26 -0500
Date: Tue, 8 Nov 2011 14:29:35 +0100
From: Karel Zak <kzak@redhat.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Gerd Hoffmann <kraxel@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Alexander Graf <agraf@suse.de>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
Message-ID: <20111108132935.GE3322@nb.net.home>
References: <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de> <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com> <4EB7B1A9.9000409@redhat.com> <alpine.LFD.2.02.1111071333350.2815@tux.localdomain> <4EB7CA52.5050409@redhat.com> <20111107122902.GA24685@thunk.org> <CAOJsxLGuRtWHbOugqHoxCNDmCrtiLFh7xMo8BVGNprG3GoanOQ@mail.gmail.com> <20111107124757.GC24685@thunk.org> <CAOJsxLGeyvv93YT244nMy59wKS8hkR1_NE6+6zEvzJiR0r2zRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLGeyvv93YT244nMy59wKS8hkR1_NE6+6zEvzJiR0r2zRQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:12:28PM +0200, Pekka Enberg wrote:
> On Mon, Nov 7, 2011 at 2:47 PM, Ted Ts'o <tytso@mit.edu> wrote:
> > I don't think perf should be used as a precendent that now argues that
> > any new kernel utility should be moved into the kernel sources.  Does
> > it make sense to move all of mount, fsck, login, etc., into the kernel
> > sources?  There are far more kernel tools outside of the kernel
> > sources than inside the kernel sources.

[...]

> I don't know if it makes sense to merge the tools you've mentioned above.
> My gut feeling is that it's probably not reasonable - there's already a
> community working on it with their own development process and coding
> style. I don't think there's a simple answer to this but I don't agree with
> your rather extreme position that all userspace tools should be kept out
> of the kernel tree.

Ted's position is not extreme. He follows the simple and exactly defined
border between userspace and kernel. The native userspace feature is
variability and substitutability.

The util-linux package is really nice example:

  - you don't have to use it, you can use busybox

  - we have currently three implementation of login(1), many getty 
    implementations, etc.

  - it's normal that people use the latest util-linux releases with very 
    old kernels (in year 2008 I had report from person with kernel 2.4:-)

  - userspace is very often about portability -- it's crazy, but some people
    use some utils from util-linux on Hurd, Solaris and BSD (including very
    Linux specific things like mkswap and hwclock)


Anyway, I agree that small one-man projects are ineffective for
important system tools -- it's usually better to merge things into
large projects with reliable infrastructure and alive community (here
I agree with Lennart's idea to have 3-5 projects for whole low-level
userspace). 

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
