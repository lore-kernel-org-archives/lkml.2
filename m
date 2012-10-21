Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2JUM7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:59:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64415 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2JUM7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:59:39 -0400
Date: Sun, 21 Oct 2012 14:59:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121021125933.GC19535@gmail.com>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
 <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
 <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
 <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
 <20121020181425.GA11191@liondog.tnic>
 <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
 <20121021110329.GA7024@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121021110329.GA7024@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Oct 21, 2012 at 01:07:31PM +1000, Dave Airlie wrote:
> > Why couldn't this script just be a wrapper around qemu
> 
> It can be.  Here is my ususual one:
> 
> #!/bin/sh
> 
> /opt/qemu/bin/qemu-system-x86_64 \
> 	-m 1500 \
> 	-enable-kvm \
> 	-drive if=none,file=/home/hch/qemu-root.img,cache=none,id=root \

You are wrong on three counts:

 - As I mentioned it in my first mail to you this is not the 
   same as 'vm run': you still have a qemu-root.img while 
   tools/kvm does not ...

   'vm run' works without having any disk image around, it just 
   uses the existing distro binaries and boots them, sharing the 
   host file system.

 - automatic, transparent host filesystem sharing is another 
   useful feature: I can copy files in/out of the virtual 
   machine using the host filesystem.

 - transparent networking is up and running straight away

But yeah, I guess if you ignore enough key tools/kvm/ features 
then you will eventually be right: it's really just the same as 
Qemu and has no place in the kernel repo ;-)

Thanks,

	Ingo
