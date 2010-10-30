Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0J3IMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 04:12:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52253 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0J3IMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 04:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gPGQg3YF879Q7TFhMTRlMlw5su+oIztfZQ+iawPODPV6wxZTnuXPW78FqrRL7EKHnz
         YtXEn4vWh4cDAQmEAnx6qqsyLJ7ZcmFZEB00BiAoHmtsQyFd2kCJmFDg+J/Ft/4dKONJ
         P4DarO4mIYL0dl8JEPlgyTYt1FLWompW19NPY=
MIME-Version: 1.0
In-Reply-To: <AANLkTimE=uzwhDMz_-jVWKyb9NAONGuVvVo5KbjkkZVu@mail.gmail.com>
References: <4CCBC8B1.2080808@in.ibm.com>
	<AANLkTimE=uzwhDMz_-jVWKyb9NAONGuVvVo5KbjkkZVu@mail.gmail.com>
Date: Sat, 30 Oct 2010 16:12:15 +0800
Message-ID: <AANLkTikXAde1yLZkB80GOjWu-sFZAvv0SL566rWssD1k@mail.gmail.com>
Subject: Re: [s390] 2.6.36-git14 build break - fs/compat.c :631
 (PAGE_CACHE_MASK undeclared)
From: wu zhangjin <wuzhangjin@gmail.com>
To: Sachin Sant <sachinp@in.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
        linux-mips <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Seems Linus added that patch, add him in this loop)

On Sat, Oct 30, 2010 at 4:01 PM, wu zhangjin <wuzhangjin@gmail.com> wrote:
> The same problem on MIPS.
>
> Perhaps this can help:
>
> $ git diff
> diff --git a/fs/compat.c b/fs/compat.c
> index ff66c0d..c580c32 100644
> --- a/fs/compat.c
> +++ b/fs/compat.c
> @@ -49,6 +49,7 @@
>  #include <linux/eventpoll.h>
>  #include <linux/fs_struct.h>
>  #include <linux/slab.h>
> +#include <linux/pagemap.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/mmu_context.h>
>
> I'm not sure if this is a good fixup, because the problem is
> introduced by MAX_RW_COUNT defined in include/linux/fs.h:
>
> #define MAX_RW_COUNT (INT_MAX & PAGE_CACHE_MASK)
>
> and the PAGE_CACHE_MASK is defined in pagemap.h, we may be possible to
> add <linux/pagemap.h> in include/linux/fs.h but pagemap.h has included
> <linux/fs.h> too ...
>
> Regards,
> Wu Zhangjin
>
> On Sat, Oct 30, 2010 at 3:26 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
>> Latest 2.6.36 git [commit 44234d0c46...] fails to build on s390x with
>> following error :
>>
>> fs/compat.c: In function compat_rw_copy_check_uvector:
>> fs/compat.c:631: error: PAGE_CACHE_MASK undeclared (first use in this
>> function)
>> fs/compat.c:631: error: (Each undeclared identifier is reported only once
>> fs/compat.c:631: error: for each function it appears in.)
>> make[1]: *** [fs/compat.o] Error 1
>>
>> The code in question was added via following commit:
>>
>> commit 435f49a518c78eec8e2edbbadd912737246cbe20
>> readv/writev: do the same MAX_RW_COUNT truncation that read/write does
>>
>> Thanks
>> -Sachin
>
