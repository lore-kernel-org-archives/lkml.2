Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2JUOCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 10:02:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39929 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2JUOCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 10:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <20121021125933.GC19535@gmail.com>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
	<20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
	<CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
	<20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
	<20121020181425.GA11191@liondog.tnic>
	<CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
	<20121021110329.GA7024@infradead.org>
	<20121021125933.GC19535@gmail.com>
Date: Sun, 21 Oct 2012 16:02:44 +0200
Message-ID: <CAFLxGvzLOa-BibZ39_yMEC70AseEPbtjcNGk6jLwaAVsU2ujwA@mail.gmail.com>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Airlie <airlied@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 2:59 PM, Ingo Molnar <mingo@kernel.org> wrote:
> You are wrong on three counts:
>
>  - As I mentioned it in my first mail to you this is not the
>    same as 'vm run': you still have a qemu-root.img while
>    tools/kvm does not ...
>
>    'vm run' works without having any disk image around, it just
>    uses the existing distro binaries and boots them, sharing the
>    host file system.
>
>  - automatic, transparent host filesystem sharing is another
>    useful feature: I can copy files in/out of the virtual
>    machine using the host filesystem.
>
>  - transparent networking is up and running straight away

qemu supports all these features.
E.g. to access the host fs use:
qemu ... \
  -fsdev local,security_model=passthrough,id=fsdev-root,path=/your/root/,readonly
\
  -device virtio-9p-pci,id=fs-root,fsdev=fsdev-root,mount_tag=rootshare

-- 
Thanks,
//richard
