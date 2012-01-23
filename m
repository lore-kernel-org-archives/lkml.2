Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab2AWRWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:22:30 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36292 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2AWRW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:22:28 -0500
MIME-Version: 1.0
In-Reply-To: <1327116249-18274-1-git-send-email-gada.kashyap@gmail.com>
References: <1327116249-18274-1-git-send-email-gada.kashyap@gmail.com>
Date: Mon, 23 Jan 2012 09:22:27 -0800
X-Google-Sender-Auth: WUej2h_SIDZK7NZy-9ic0iakKtI
Message-ID: <CAPz4a6AUAMxcMkVkgc9UJ1tok36jNE5hZzJc_9n5EJqRQCcz2w@mail.gmail.com>
Subject: Re: [PATCH 5/5] Staging: android: Add KERN_ facility level in printk
 () in pmem.c
From: Dima Zavin <dima@android.com>
To: Kashyap Gada <gada.kashyap@gmail.com>
Cc: gregkh@suse.de, rebecca@android.com, rschultz@google.com,
        jgennis@google.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We really should just get rid of pmem.c altogether. We will remove it
from our android common tree too. We don't actually use it anymore in
any of our products. There are some legacy users of it, like Qualcomm,
but I'm sure they have a bunch of patches on top of it and thus are
maintaining it separately anyway.

--Dima

On Fri, Jan 20, 2012 at 7:24 PM, Kashyap Gada <gada.kashyap@gmail.com> wrote:
> diff --git a/drivers/staging/android/pmem.c b/drivers/staging/android/pmem.c
> index 65ba61a..c589c0c 100644
> --- a/drivers/staging/android/pmem.c
> +++ b/drivers/staging/android/pmem.c
> @@ -831,7 +831,7 @@ static int pmem_connect(unsigned long connect, struct file *file)
>        src_file = fget_light(connect, &put_needed);
>        DLOG("connect %p to %p\n", file, src_file);
>        if (!src_file) {
> -               printk("pmem: src file not found!\n");
> +               printk(KERN_ERR "pmem: src file not found!\n");
>                ret = -EINVAL;
>                goto err_no_file;
>        }
> @@ -934,7 +934,7 @@ int pmem_remap(struct pmem_region *region, struct file *file,
>        if (unlikely(!PMEM_IS_PAGE_ALIGNED(region->offset) ||
>                 !PMEM_IS_PAGE_ALIGNED(region->len))) {
>  #if PMEM_DEBUG
> -               printk("pmem: request for unaligned pmem suballocation "
> +               printk(KERN_DEBUG "pmem: request for unaligned pmem suballocation "
>                       "%lx %lx\n", region->offset, region->len);
>  #endif
>                return -EINVAL;
> --
> 1.7.5.4
>
