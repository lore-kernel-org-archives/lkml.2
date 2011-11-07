Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1KGM33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:29:29 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:44399 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab1KGM31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:29:27 -0500
Date: Mon, 7 Nov 2011 07:29:02 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Pekka Enberg <penberg@kernel.org>,
        Alexander Graf <agraf@suse.de>, Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Blue Swirl <blauwirbel@gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
Message-ID: <20111107122902.GA24685@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Pekka Enberg <penberg@kernel.org>, Alexander Graf <agraf@suse.de>,
	Avi Kivity <avi@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	"linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
	qemu-devel Developers <qemu-devel@nongnu.org>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Blue Swirl <blauwirbel@gmail.com>
References: <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
 <4EB67D17.7000701@redhat.com>
 <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
 <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
 <877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>
 <CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>
 <4EB7B1A9.9000409@redhat.com>
 <alpine.LFD.2.02.1111071333350.2815@tux.localdomain>
 <4EB7CA52.5050409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB7CA52.5050409@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 01:08:50PM +0100, Gerd Hoffmann wrote:
> 
> perf *is* an exception today.
> 
> It might make sense to change that.  But IMHO it only makes sense if
> there is a really broad agreement on it and other core stuff moves into
> the kernel too.  Then you'll be able to get advantages out of it.  For
> example standardizing the process to create an initramfs (using the
> userspace tools shipped with the kernel) instead of having each distro
> creating its own way.

I wish distributions had standardized on a single initramfs, sure.
But that doesn't mean that the only way to do this is to merge
userspace code into the kernel source tree.  Everybody uses fsck,
originally from the e2fsprogs source tree, and now from util-linux-ng,
and that isn't merged into the kernel sources.

And I think would be actively *harmful* to merge util-linux-ng into
the kernel sources.  For a variety of reasons, you may want to upgrade
util-linux-ng, and not the kernel, or the kernel, and not
util-linux-ng.  If you package the two sources together, it becomes
unclear what versions of the kernel will work with which versions of
util-linux-ng, and vice versa.  Suppose you need to fix a security bug
in some program that lives in util-linux-ng.  If it was bundled inside
the kernel, a distribution would now have to release a kernel source
package.  Does that mean that it will have to ship the a new set of
kernel binaries?  Or does the distribution have to ship multiple
binary packages that derive from the differently versioned source
packages?

And the same problems will exist with kvm-tool.  What if you need to
release a new version of kvm-tool?  Does that mean that you have to
release a new set of kernel binaries?  It's a mess, and there's a
reason why we don't have glibc, e2fsprogs, xfsprogs, util-linux-ng,
etc., all packaged into the kernel sources.

Because it's a stupid, idiotic thing to do.

						- Ted
