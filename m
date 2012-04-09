Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab2DIHcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:32:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab2DIHcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:32:46 -0400
Date: Mon, 9 Apr 2012 10:33:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Dongsu Park <advance38@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: tools/virtio: Compile errors
Message-ID: <20120409073258.GB12014@redhat.com>
References: <20120208160405.GA1587@gmail.com>
 <20120208164736.GA31066@redhat.com>
 <CAEH94Lgha0Ug2Tk9-22=B58tb9xWG5knAfB04aVbW63F5Xi6TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEH94Lgha0Ug2Tk9-22=B58tb9xWG5knAfB04aVbW63F5Xi6TA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 02:02:53PM +0800, Zhi Yong Wu wrote:
> On Thu, Feb 9, 2012 at 12:47 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Wed, Feb 08, 2012 at 05:04:05PM +0100, Dongsu Park wrote:
> >> Hi,
> >>
> >> there are compile problems under tools/virtio.
> >> If I simply run make,
> >>
> >> ~/linuxsrc/linux-3.2/tools/virtio $ make
> >> gcc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
> >> -fno-strict-overflow  -MMD   -c -o virtio_ring.o
> >> ../../drivers/virtio/virtio_ring.c
> >> ../../drivers/virtio/virtio_ring.c:24:26: fatal error: linux/module.h:
> >> No such file or directory
> >> compilation terminated.
> >> make: *** [virtio_ring.o] Error 1
> >
> >
> >> By the way, my system is Ubuntu 11.10 with Kernel 3.2.
> >>
> >> Cheers,
> >> Dongsu
> >
> > This patch is missing - I'll put it upstream.
> >
> > --->
> >
> > tools/virtio: add module.h stub
> >
> > make it build with linux 3.2
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >
> > diff --git a/tools/virtio/linux/module.h b/tools/virtio/linux/module.h
> > new file mode 100644
> > index 0000000..96868eb
> > --- /dev/null
> > +++ b/tools/virtio/linux/module.h
> > @@ -0,0 +1,3 @@
> > +#ifndef LINUX_MODULE_H
> > +#define LINUX_MODULE_H
> > +#endif
> After the patch was applied in my env, i met another issue.
> [root@f15 virtio]# make test
> cc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
> -fno-strict-overflow  -MMD   -c -o virtio_ring.o
> ../../drivers/virtio/virtio_ring.c
> ../../drivers/virtio/virtio_ring.c: In function \u2018virtqueue_add_buf\u2019:
> ../../drivers/virtio/virtio_ring.c:277:2: warning: implicit
> declaration of function \u2018wmb\u2019
> [-Wimplicit-function-declaration]
> ../../drivers/virtio/virtio_ring.c: In function \u2018virtqueue_get_buf\u2019:
> ../../drivers/virtio/virtio_ring.c:437:2: warning: implicit
> declaration of function \u2018rmb\u2019
> [-Wimplicit-function-declaration]
> cc   virtio_test.o virtio_ring.o   -o virtio_test
> virtio_ring.o: In function `virtqueue_add_buf':
> /home/zwu/work/kernel/vhost-scsi/tools/virtio/../../drivers/virtio/virtio_ring.c:277:
> undefined reference to `wmb'
> virtio_ring.o: In function `virtqueue_get_buf':
> /home/zwu/work/kernel/vhost-scsi/tools/virtio/../../drivers/virtio/virtio_ring.c:437:
> undefined reference to `rmb'
> collect2: ld returned 1 exit status
> make: *** [virtio_test] Error 1

On which kernel version does this trigger?

> 
> 
> -- 
> Regards,
> 
> Zhi Yong Wu
