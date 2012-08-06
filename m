Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab2HFMkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:40:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49598 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab2HFMks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <1344256158-20358-1-git-send-email-amwang@redhat.com>
References: <1344256158-20358-1-git-send-email-amwang@redhat.com>
Date: Mon, 6 Aug 2012 21:40:47 +0900
Message-ID: <CAC5umyixTGiy-1+8G5m5pULA4X38=s=DE5XovMuR9M0zNFSjmg@mail.gmail.com>
Subject: Re: [Patch] string: do not export memweight() to userspace
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>, Joern Engel <joern@logfs.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/6 Cong Wang <amwang@redhat.com>:
> From: WANG Cong <xiyou.wangcong@gmail.com>
>
> This patch fixes the following warning:
>
> usr/include/linux/string.h:8: userspace cannot reference function or variable defined in the kernel

Thanks for finding this problem.
Looks good to me.

> Cc: Akinobu Mita <akinobu.mita@gmail.com>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> ---
> diff --git a/include/linux/string.h b/include/linux/string.h
> index ffe0442..b917881 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -144,8 +144,8 @@ static inline bool strstarts(const char *str, const char *prefix)
>  {
>         return strncmp(str, prefix, strlen(prefix)) == 0;
>  }
> -#endif
>
>  extern size_t memweight(const void *ptr, size_t bytes);
>
> +#endif /* __KERNEL__ */
>  #endif /* _LINUX_STRING_H_ */
