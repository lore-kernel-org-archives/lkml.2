Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab1EaSUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:20:48 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36014 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751766Ab1EaSUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:20:47 -0400
Subject: Re: [TRIVIAL PATCH next 13/15] fs: Convert vmalloc/memset to
 vzalloc
From: Alex Elder <aelder@sgi.com>
Reply-To: <aelder@sgi.com>
To: Joe Perches <joe@perches.com>
CC: Jan Harkes <jaharkes@cs.cmu.edu>, <coda@cs.cmu.edu>,
        Jiri Kosina <trivial@kernel.org>, <xfs-masters@oss.sgi.com>,
        <codalist@TELEMANN.coda.cs.cmu.edu>, <linux-kernel@vger.kernel.org>,
        <reiserfs-devel@vger.kernel.org>, <xfs@oss.sgi.com>
In-Reply-To: <4561db676a209fff984a75ade2f552ddbfabb95b.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
	 <4561db676a209fff984a75ade2f552ddbfabb95b.1306603968.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 13:20:39 -0500
Message-ID: <1306866039.2865.26.camel@doink>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.232.50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 10:36 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/coda/coda_linux.h    |    5 ++---
>  fs/reiserfs/journal.c   |    9 +++------
>  fs/reiserfs/resize.c    |    4 +---
>  fs/xfs/linux-2.6/kmem.h |    7 +------
>  4 files changed, 7 insertions(+), 18 deletions(-)
> 

Acked-by: Alex Elder <aelder@sgi.com>

. . .

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



