Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2DIHlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:41:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50149 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2DIHlg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:41:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120409073258.GB12014@redhat.com>
References: <20120208160405.GA1587@gmail.com>
	<20120208164736.GA31066@redhat.com>
	<CAEH94Lgha0Ug2Tk9-22=B58tb9xWG5knAfB04aVbW63F5Xi6TA@mail.gmail.com>
	<20120409073258.GB12014@redhat.com>
Date: Mon, 9 Apr 2012 15:41:36 +0800
Message-ID: <CAEH94LjQxT5AkZjskdMMkryvcw3Q3fyVp1RGmKsFtaHda2V=TA@mail.gmail.com>
Subject: Re: tools/virtio: Compile errors
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dongsu Park <advance38@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 3:33 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Mon, Apr 09, 2012 at 02:02:53PM +0800, Zhi Yong Wu wrote:
>> On Thu, Feb 9, 2012 at 12:47 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> > On Wed, Feb 08, 2012 at 05:04:05PM +0100, Dongsu Park wrote:
>> >> Hi,
>> >>
>> >> there are compile problems under tools/virtio.
>> >> If I simply run make,
>> >>
>> >> ~/linuxsrc/linux-3.2/tools/virtio $ make
>> >> gcc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
>> >> -fno-strict-overflow  -MMD   -c -o virtio_ring.o
>> >> ../../drivers/virtio/virtio_ring.c
>> >> ../../drivers/virtio/virtio_ring.c:24:26: fatal error: linux/module.h:
>> >> No such file or directory
>> >> compilation terminated.
>> >> make: *** [virtio_ring.o] Error 1
>> >
>> >
>> >> By the way, my system is Ubuntu 11.10 with Kernel 3.2.
>> >>
>> >> Cheers,
>> >> Dongsu
>> >
>> > This patch is missing - I'll put it upstream.
>> >
>> > --->
>> >
>> > tools/virtio: add module.h stub
>> >
>> > make it build with linux 3.2
>> >
>> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> >
>> > diff --git a/tools/virtio/linux/module.h b/tools/virtio/linux/module.h
>> > new file mode 100644
>> > index 0000000..96868eb
>> > --- /dev/null
>> > +++ b/tools/virtio/linux/module.h
>> > @@ -0,0 +1,3 @@
>> > +#ifndef LINUX_MODULE_H
>> > +#define LINUX_MODULE_H
>> > +#endif
>> After the patch was applied in my env, i met another issue.
>> [root@f15 virtio]# make test
>> cc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
>> -fno-strict-overflow  -MMD   -c -o virtio_ring.o
>> ../../drivers/virtio/virtio_ring.c
>> ../../drivers/virtio/virtio_ring.c: In function \u2018virtqueue_add_buf\u2019:
>> ../../drivers/virtio/virtio_ring.c:277:2: warning: implicit
>> declaration of function \u2018wmb\u2019
>> [-Wimplicit-function-declaration]
>> ../../drivers/virtio/virtio_ring.c: In function \u2018virtqueue_get_buf\u2019:
>> ../../drivers/virtio/virtio_ring.c:437:2: warning: implicit
>> declaration of function \u2018rmb\u2019
>> [-Wimplicit-function-declaration]
>> cc   virtio_test.o virtio_ring.o   -o virtio_test
>> virtio_ring.o: In function `virtqueue_add_buf':
>> /home/zwu/work/kernel/vhost-scsi/tools/virtio/../../drivers/virtio/virtio_ring.c:277:
>> undefined reference to `wmb'
>> virtio_ring.o: In function `virtqueue_get_buf':
>> /home/zwu/work/kernel/vhost-scsi/tools/virtio/../../drivers/virtio/virtio_ring.c:437:
>> undefined reference to `rmb'
>> collect2: ld returned 1 exit status
>> make: *** [virtio_test] Error 1
>
> On which kernel version does this trigger?
[root@f15 linux-2.6]# git log
commit e22057c8599373e5caef0bc42bdb95d2a361ab0d
Merge: 496b919 df7a3ee
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Mar 24 12:20:25 2012 -0700

    Merge tag 'stable/for-linus-3.4-tag-two' of git://git.kernel.org/pub/scm/lin

    Pull more xen updates from Konrad Rzeszutek Wilk:
     "One tiny feature that accidentally got lost in the initial git pull:
       * Add fast-EOI acking of interrupts (clear a bit instead of
         hypercall)
      And bug-fixes:
       * Fix CPU bring-up code missing a call to notify other subsystems.
       * Fix reading /sys/hypervisor even if PVonHVM drivers are not loaded.
       * In Xen ACPI processor driver: remove too verbose WARN messages, fix
         up the Kconfig dependency to be a module by default, and add
         dependency on CPU_FREQ.
       * Disable CPU frequency drivers from loading when booting under Xen
         (as we want the Xen ACPI processor to be used instead).
       * Cleanups in tmem code."

    * tag 'stable/for-linus-3.4-tag-two' of git://git.kernel.org/pub/scm/linux/k
      xen/acpi: Fix Kconfig dependency on CPU_FREQ
[root@f15 linux-2.6]# cd tools/virtio/
[root@f15 virtio]# ls
linux  Makefile  vhost_test  virtio_test.c  virtio_test.d  virtio_test.o
[root@f15 virtio]# make test
cc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
-fno-strict-overflow  -MMD   -c -o virtio_ring.o
../../drivers/virtio/virtio_ring.c
../../drivers/virtio/virtio_ring.c:25:27: fatal error:
linux/hrtimer.h: No such file or directory
compilation terminated.
make: *** [virtio_ring.o] Error 1
[root@f15 virtio]# touch linux/hrtimer.h
[root@f15 virtio]# vi linux/hrtimer.h
[root@f15 virtio]# make test
cc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
-fno-strict-overflow  -MMD   -c -o virtio_ring.o
../../drivers/virtio/virtio_ring.c
../../drivers/virtio/virtio_ring.c: In function \u2018virtqueue_add_buf\u2019:
../../drivers/virtio/virtio_ring.c:277:2: warning: implicit
declaration of function \u2018wmb\u2019
[-Wimplicit-function-declaration]
../../drivers/virtio/virtio_ring.c: In function \u2018virtqueue_get_buf\u2019:
../../drivers/virtio/virtio_ring.c:437:2: warning: implicit
declaration of function \u2018rmb\u2019
[-Wimplicit-function-declaration]
cc   virtio_test.o virtio_ring.o   -o virtio_test
virtio_ring.o: In function `virtqueue_add_buf':
/home/zwu/work/kernel/vhost-scsi/tools/virtio/../../drivers/virtio/virtio_ring.c:277:
undefined reference to `wmb'
virtio_ring.o: In function `virtqueue_get_buf':
/home/zwu/work/kernel/vhost-scsi/tools/virtio/../../drivers/virtio/virtio_ring.c:437:
undefined reference to `rmb'
collect2: ld returned 1 exit status
make: *** [virtio_test] Error 1
[root@f15 virtio]#

>
>>
>>
>> --
>> Regards,
>>
>> Zhi Yong Wu



-- 
Regards,

Zhi Yong Wu
