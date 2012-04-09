Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2DIGM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 02:12:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2DIGM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 02:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120208164736.GA31066@redhat.com>
References: <20120208160405.GA1587@gmail.com>
	<20120208164736.GA31066@redhat.com>
Date: Mon, 9 Apr 2012 14:12:57 +0800
Message-ID: <CAEH94Li15C60V1AHfbm6_9TCNcFKWFs543BVWrwTDOgsuo9+BQ@mail.gmail.com>
Subject: Re: tools/virtio: Compile errors
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dongsu Park <advance38@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 12:47 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Wed, Feb 08, 2012 at 05:04:05PM +0100, Dongsu Park wrote:
>> Hi,
>>
>> there are compile problems under tools/virtio.
>> If I simply run make,
>>
>> ~/linuxsrc/linux-3.2/tools/virtio $ make
>> gcc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
>> -fno-strict-overflow  -MMD   -c -o virtio_ring.o
>> ../../drivers/virtio/virtio_ring.c
>> ../../drivers/virtio/virtio_ring.c:24:26: fatal error: linux/module.h:
>> No such file or directory
>> compilation terminated.
>> make: *** [virtio_ring.o] Error 1
>
>
>> By the way, my system is Ubuntu 11.10 with Kernel 3.2.
>>
>> Cheers,
>> Dongsu
>
> This patch is missing - I'll put it upstream.
>
> --->
>
> tools/virtio: add module.h stub
>
> make it build with linux 3.2
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> diff --git a/tools/virtio/linux/module.h b/tools/virtio/linux/module.h
> new file mode 100644
> index 0000000..96868eb
> --- /dev/null
> +++ b/tools/virtio/linux/module.h
> @@ -0,0 +1,3 @@
> +#ifndef LINUX_MODULE_H
> +#define LINUX_MODULE_H
> +#endif
I found that it is not only lack of this head file when i ran "make
test", but also depend on other head files.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Regards,

Zhi Yong Wu
