Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0KERKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:10:04 -0400
Received: from relay1.sgi.com ([192.48.179.29]:49998 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab0KERKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:10:03 -0400
Subject: Re: [PATCH 41/49] fs/xfs: Use vzalloc
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <10acc19712bf3d1e0ea68e7c16e1723922541249.1288925425.git.joe@perches.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	 <10acc19712bf3d1e0ea68e7c16e1723922541249.1288925425.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 12:09:45 -0500
Message-ID: <1288976985.2295.25.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Nov 2010 17:09:46.0229 (UTC) FILETIME=[3F1F5A50:01CB7D0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 20:08 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/xfs/linux-2.6/kmem.h |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/kmem.h b/fs/xfs/linux-2.6/kmem.h
> index f7c8f7a..292eff1 100644
> --- a/fs/xfs/linux-2.6/kmem.h
> +++ b/fs/xfs/linux-2.6/kmem.h
> @@ -61,12 +61,7 @@ extern void  kmem_free(const void *);
>  
>  static inline void *kmem_zalloc_large(size_t size)
>  {
> -	void *ptr;
> -
> -	ptr = vmalloc(size);
> -	if (ptr)
> -		memset(ptr, 0, size);
> -	return ptr;
> +	return vzalloc(size);
>  }
>  static inline void kmem_free_large(void *ptr)
>  {

Looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

