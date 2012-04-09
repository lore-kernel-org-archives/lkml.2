Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2DIJAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 05:00:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab2DIJAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 05:00:39 -0400
Date: Mon, 9 Apr 2012 12:00:49 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Dongsu Park <advance38@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: tools/virtio: Compile errors
Message-ID: <20120409090048.GA28439@redhat.com>
References: <20120208160405.GA1587@gmail.com>
 <20120208164736.GA31066@redhat.com>
 <CAEH94Lgha0Ug2Tk9-22=B58tb9xWG5knAfB04aVbW63F5Xi6TA@mail.gmail.com>
 <20120409073258.GB12014@redhat.com>
 <CAEH94LjQxT5AkZjskdMMkryvcw3Q3fyVp1RGmKsFtaHda2V=TA@mail.gmail.com>
 <20120409075548.GC27771@redhat.com>
 <CAEH94LiYeGoDAcboi9u1gna_v4cxL+Hc33cGL4ExMxtj+ss6qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEH94LiYeGoDAcboi9u1gna_v4cxL+Hc33cGL4ExMxtj+ss6qA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 04:49:14PM +0800, Zhi Yong Wu wrote:
> On Mon, Apr 9, 2012 at 3:55 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Mon, Apr 09, 2012 at 03:41:36PM +0800, Zhi Yong Wu wrote:
> >> On Mon, Apr 9, 2012 at 3:33 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> >> > On Mon, Apr 09, 2012 at 02:02:53PM +0800, Zhi Yong Wu wrote:
> >> >> On Thu, Feb 9, 2012 at 12:47 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> >> >> > On Wed, Feb 08, 2012 at 05:04:05PM +0100, Dongsu Park wrote:
> >> >> >> Hi,
> >> >> >>
> >> >> >> there are compile problems under tools/virtio.
> >> >> >> If I simply run make,
> >> >> >>
> >> >> >> ~/linuxsrc/linux-3.2/tools/virtio $ make
> >> >> >> gcc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
> >> >> >> -fno-strict-overflow  -MMD   -c -o virtio_ring.o
> >> >> >> ../../drivers/virtio/virtio_ring.c
> >> >> >> ../../drivers/virtio/virtio_ring.c:24:26: fatal error: linux/module.h:
> >> >> >> No such file or directory
> >> >> >> compilation terminated.
> >> >> >> make: *** [virtio_ring.o] Error 1
> >> >> >
> >> >> >
> >> >> >> By the way, my system is Ubuntu 11.10 with Kernel 3.2.
> >> >> >>
> >> >> >> Cheers,
> >> >> >> Dongsu
> >> >> >
> >> >> > This patch is missing - I'll put it upstream.
> >> >> >
> >> >> > --->
> >> >> >
> >> >> > tools/virtio: add module.h stub
> >> >> >
> >> >> > make it build with linux 3.2
> >> >> >
> >> >> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >> >> >
> >> >> > diff --git a/tools/virtio/linux/module.h b/tools/virtio/linux/module.h
> >> >> > new file mode 100644
> >> >> > index 0000000..96868eb
> >> >> > --- /dev/null
> >> >> > +++ b/tools/virtio/linux/module.h
> >> >> > @@ -0,0 +1,3 @@
> >> >> > +#ifndef LINUX_MODULE_H
> >> >> > +#define LINUX_MODULE_H
> >> >> > +#endif
> >> >> After the patch was applied in my env, i met another issue.
> >> >> [root@f15 virtio]# make test
> >> >> cc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
> >> >> -fno-strict-overflow  -MMD   -c -o virtio_ring.o
> >> >> ../../drivers/virtio/virtio_ring.c
> >> >> ../../drivers/virtio/virtio_ring.c: In function \u2018virtqueue_add_buf\u2019:
> >> >> ../../drivers/virtio/virtio_ring.c:277:2: warning: implicit
> >> >> declaration of function \u2018wmb\u2019
> >> >> [-Wimplicit-function-declaration]
> >> >> ../../drivers/virtio/virtio_ring.c: In function \u2018virtqueue_get_buf\u2019:
> >> >> ../../drivers/virtio/virtio_ring.c:437:2: warning: implicit
> >> >> declaration of function \u2018rmb\u2019
> >> >> [-Wimplicit-function-declaration]
> >> >> cc   virtio_test.o virtio_ring.o   -o virtio_test
> >> >> virtio_ring.o: In function `virtqueue_add_buf':
> >> >> /home/zwu/work/kernel/vhost-scsi/tools/virtio/../../drivers/virtio/virtio_ring.c:277:
> >> >> undefined reference to `wmb'
> >> >> virtio_ring.o: In function `virtqueue_get_buf':
> >> >> /home/zwu/work/kernel/vhost-scsi/tools/virtio/../../drivers/virtio/virtio_ring.c:437:
> >> >> undefined reference to `rmb'
> >> >> collect2: ld returned 1 exit status
> >> >> make: *** [virtio_test] Error 1
> >> >
> >> > On which kernel version does this trigger?
> >> [root@f15 linux-2.6]# git log
> >> commit e22057c8599373e5caef0bc42bdb95d2a361ab0d
> >> Merge: 496b919 df7a3ee
> >> Author: Linus Torvalds <torvalds@linux-foundation.org>
> >> Date:   Sat Mar 24 12:20:25 2012 -0700
> >
> > Update to 3.4-rc2 and most of the issues go away
> > (there's still a build breakage with a missing
> > flag to dev_cleanup, I'm fixing this up for now
> > you can just pass false).
> thanks.
> By the way,  what does it mean as below?
> [root@f15 virtio]# ./virtio_test
> spurious wakeus: 0x4
> [root@f15 virtio]# ./virtio_test -h
> Usage: virtio_test [--help] [--no-indirect] [--no-event-idx]
> spurious wakeus: 0x2
> [root@f15 virtio]# ./virtio_test --no-indirect
> spurious wakeus: 0x4
> [root@f15 virtio]# ./virtio_test --no-event-idx
> spurious wakeus: 0x7
> [root@f15 virtio]# ./virtio_test
> spurious wakeus: 0x5
> [root@f15 virtio]# ./virtio_test
> spurious wakeus: 0x2
> [root@f15 virtio]# ./virtio_test
> spurious wakeus: 0x3
> [root@f15 virtio]# ./virtio_test
> spurious wakeus: 0x5
> [root@f15 virtio]# ./virtio_test
> spurious wakeus: 0x4

What does 'spurious wakeups' mean?

What we detect here is a nested interrupt delivered
before the handler for the original one had a
chance to run.

>
> 
> 
> 
> -- 
> Regards,
> 
> Zhi Yong Wu
