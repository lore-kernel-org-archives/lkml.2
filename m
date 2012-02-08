Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2BHQjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:39:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33398 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2BHQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:39:06 -0500
Date: Wed, 8 Feb 2012 17:38:34 +0100
From: Dongsu Park <advance38@gmail.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: tools/virtio: Compile errors
Message-ID: <20120208163834.GA26089@gmail.com>
References: <20120208160405.GA1587@gmail.com>
 <CAHdPZaOLfia_jgT3piNmDT_5SmYsRfNkF3p3wT98iW7b61462Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHdPZaOLfia_jgT3piNmDT_5SmYsRfNkF3p3wT98iW7b61462Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.02.2012 11:11, devendra.aaru wrote:
> On Wed, Feb 8, 2012 at 11:04 AM, Dongsu Park <advance38@gmail.com> wrote:
> > Hi,
> >
> > there are compile problems under tools/virtio.
> > If I simply run make,
> >
> > ~/linuxsrc/linux-3.2/tools/virtio $ make
> > gcc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
> > -fno-strict-overflow  -MMD   -c -o virtio_ring.o
> > ../../drivers/virtio/virtio_ring.c
> > ../../drivers/virtio/virtio_ring.c:24:26: fatal error: linux/module.h:
> > No such file or directory
> > compilation terminated.
> > make: *** [virtio_ring.o] Error 1
> >
> compile with make mod.

Yes, I know "make mod" is already working.
I'm also able to load the kernel module vhost_test.ko. That's fine.

But "make test" isn't still working.
How can I build virtio_test, the userspace test program?

Dongsu

> > Of course that's supposed to be a simple error in CFLAGS in Makefile,
> > so I tried it again modifying CFLAGS, from "-I ../../usr/include" to
> > "-I ../../include". But this time it's another compile error.
> >
> > ~/linuxsrc/linux-3.2/tools/virtio $ make
> > gcc -g -O2 -Wall -I. -I ../../include/ -Wno-pointer-sign
> > -fno-strict-overflow  -MMD   -c -o virtio_ring.o
> > ../../drivers/virtio/virtio_ring.c
> > In file included from ./linux/virtio.h:11:0,
> >                 from ../../drivers/virtio/virtio_ring.c:19:
> > ../../include/linux/types.h:13:2: warning: #warning "Attempt to use
> > kernel headers from user space, see
> > http://kernelnewbies.org/KernelHeaders"
> > In file included from ../../include/linux/module.h:9:0,
> >                 from ../../drivers/virtio/virtio_ring.c:24:
> > ../../include/linux/list.h:24:42: warning: ‘struct list_head’ declared
> > inside parameter list
> > ../../include/linux/list.h:24:42: warning: its scope is only this
> > definition or declaration, which is probably not what you want
> > ../../include/linux/list.h: In function ‘INIT_LIST_HEAD’:
> > ../../include/linux/list.h:26:6: error: dereferencing pointer to
> > incomplete type
> > ../../include/linux/list.h:27:6: error: dereferencing pointer to
> > incomplete type
> > ../../include/linux/list.h: At top level:
> > ../../include/linux/list.h:39:17: warning: ‘struct list_head’ declared
> > inside parameter list
> >
> > ...<snip>...
> >
> > I tried again to fix it further, without success.
> > Has anyone succeeded compiling tools/virtio?
> >
> > By the way, my system is Ubuntu 11.10 with Kernel 3.2.
> >
> > Cheers,
> > Dongsu
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
