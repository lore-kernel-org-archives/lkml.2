Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1KFXUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 18:20:00 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:44734 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab1KFXT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 18:19:58 -0500
Date: Sun, 6 Nov 2011 18:19:53 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to
 test kernels
Message-ID: <20111106231953.GD4500@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Pekka Enberg <penberg@kernel.org>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Avi Kivity <avi@redhat.com>,
	"kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
	qemu-devel Developers <qemu-devel@nongnu.org>,
	Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
 <4EB680D9.2070706@redhat.com>
 <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
 <4EB6AE34.2000907@redhat.com>
 <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
 <4EB6BAED.2030400@redhat.com>
 <4EB6BEFA.6000303@codemonkey.ws>
 <20111106183132.GA4500@thunk.org>
 <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
 <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 06, 2011 at 08:58:20PM +0200, Pekka Enberg wrote:
> > Ted, I'm confused. Making backwards incompatible ABI changes has never
> > been on the table. Why are you bringing it up?
> 
> And btw, KVM tool is not a random userspace project - it was designed
> to live in tools/kvm from the beginning. I've explained the technical
> rationale for sharing kernel code here:
> 
> https://lkml.org/lkml/2011/11/4/150
> 
> Please also see Ingo's original rant that started the project:
> 
> http://thread.gmane.org/gmane.linux.kernel/962051/focus=962620

Because I don't buy any of these arguments.  We have the same kernel
developers working on xfs and xfsprogs, ext4 and e2fsprogs, btrfs and
btrfsprogs, and we don't have those userspace projects in the kernel
source tree.

The only excuse I can see is a hope to make random changes to the
kernel and userspace tools without having to worry about compatibility
problems, which is an argument I've seen with perf (that you have to
use the same version of perf as the kernel version, which to me is bad
software engineering).  And that's why I pointed out that you can't do
that with KVM, since we have out-of-tree userspace users, namely
qemu-kvm.

The rest of the arguments are arguments for a new effort, which is
fine --- but not an excuse for putting in the kernel source tree.

     	     	    	       	       - Ted
