Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab2JWCVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:21:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37788 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab2JWCVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <20121022101645.GL29310@redhat.com>
References: <20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
 <CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
 <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
 <20121020181425.GA11191@liondog.tnic> <CAPM=9twcHxUGgYUc27DV1AcYZbzKSbA1Bru8vK1kcWvcG0Jpkw@mail.gmail.com>
 <20121021110329.GA7024@infradead.org> <20121021125933.GC19535@gmail.com>
 <CAFLxGvzLOa-BibZ39_yMEC70AseEPbtjcNGk6jLwaAVsU2ujwA@mail.gmail.com>
 <CAOJsxLGm+Qd132i2c7q9p1_yweLiRzC4GR0-Xmx79m2==4_FAw@mail.gmail.com>
 <508510C3.2020901@redhat.com> <20121022101645.GL29310@redhat.com>
From: Asias He <asias.hejun@gmail.com>
Date: Tue, 23 Oct 2012 10:20:34 +0800
Message-ID: <CAFO3S43HEKiLtRMzYije_8K88zyhiz86HE6bUjWRvaE5cLxviA@mail.gmail.com>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 6:16 PM, Gleb Natapov <gleb@redhat.com> wrote:
> On Mon, Oct 22, 2012 at 11:24:19AM +0200, Avi Kivity wrote:
>> On 10/21/2012 05:39 PM, Pekka Enberg wrote:
>> >
>> > On Sun, Oct 21, 2012 at 5:02 PM, richard -rw- weinberger
>> > <richard.weinberger@gmail.com> wrote:
>> >> qemu supports all these features.
>> >> E.g. to access the host fs use:
>> >> qemu ... \
>> >>   -fsdev local,security_model=passthrough,id=fsdev-root,path=/your/root/,readonly
>> >> \
>> >>   -device virtio-9p-pci,id=fs-root,fsdev=fsdev-root,mount_tag=rootshare
>> >
>> > IIRC, QEMU uses SLIRP non-root zero-config networking which is much
>> > more limited than what LKVM offers out of the box.
>>
>> Curious, what are the differences?
>>
> Me too, especially as we discussed replacing SLIRP with lkvm code for
> userspace networking and decided (for reasons I do not remember) that it
> lacks futures SLIRP has. Was it host port redirection?

Yes.  Currently, there is no host to guest port forward support in lkvm.
However, it's faster than slirp.
e.g. tcp bandwidth in a 100Mb/s environment
lkvm's userspace networking ~90Mb/s  v.s qemu's slirp  ~10Mb/s

-- 
Asias He
