Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1KDPTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:19:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49424 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1KDPTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:19:09 -0400
Subject: Re: [RFC/GIT PULL] Linux KVM tool for v3.2
From: Sasha Levin <levinsasha928@gmail.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
In-Reply-To: <4EB3F9CE.1050407@siemens.com>
References: <alpine.LFD.2.02.1111041037290.16959@tux.localdomain>
	 <20111104121601.GA15206@infradead.org>
	 <CAOJsxLGf78q7rR7-q4d6TizmghFcKyK3tFOAew4i2-SHrZcvhQ@mail.gmail.com>
	 <20111104130225.GA24563@infradead.org>
	 <CAOJsxLG4+-Hmpt-dfa7auEs6H1RgWWwYYs=zzb8uvJg8m10_Nw@mail.gmail.com>
	 <4EB3F9CE.1050407@siemens.com>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 04 Nov 2011 17:16:54 +0200
Message-ID: <1320419814.3334.45.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 15:42 +0100, Jan Kiszka wrote:
> On 2011-11-04 14:32, Pekka Enberg wrote:
> > I know you don't see the benefits of integrated code base but I as a
> > developer do.
> 
> IIRC, this discussion still lacks striking, concrete examples from the
> KVM tool vs. QEMU development processes.

I'll give a current example: Michael and Rusty are currently considering
a change in the virtio spec (allowing MMIO config BARs - but thats
irrelevant).

I'll quote what Anthony said about how he sees the big picture of how
this change is going to be implemented - something which we all agree
with:

On Thu, 2011-11-03 at 09:37 -0500, Anthony Liguori wrote:
> Well, what's needed before the spec is changed is an interesting question, but I 
> think the main thing is, don't commit any virtio ABI changes to vhost, QEMU, 
> NKT, or the kernel until the spec for the change has been committed.
> 
> It would be nice to have a working implementation before committing a spec 
> change.  Even nicer would be to have Acked-by's a maintainer in each area affected.

Which is pretty smart. Get a working implementation before we commit to
a spec.

Now, how would the development process look when the trees aren't
integrated? You'd try to get the kernel side stabilized, then you'd do
your usermode changes, go back to the kernel patches to fix bugs and
things people missed, which would require in turn new patches to the
usermode part, and so until you get 5-6 versions (best case) of this
change in *each* tree.

Add some technical difficulties which just make it uglier, such as
having to copy over new kernel headers into the usermode tool for each
new version you want to send (linux-headers/ dir in QEMU) and you get a
process which is not that pretty anymore :)

How would it look for an integrated project? You'd be working on the
same codebase, one series of patches would take care of both the kernel
changes and the userspace changes, this would speed up iterations and
make testing quite easier.

-- 

Sasha.

