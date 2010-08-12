Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136Ab0HLOzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 10:55:01 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44577 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab0HLOy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 10:54:59 -0400
Date: Thu, 12 Aug 2010 09:38:17 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] fs/ecryptfs: Return -ENOMEM on memory allocation
 failure
Message-ID: <20100812143816.GA938@ecryptfs>
References: <Pine.LNX.4.64.1008111211240.8669@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008111211240.8669@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Julia - Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

Tyler

On Wed Aug 11, 2010 at 12:11:41PM +0200, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In this code, 0 is returned on memory allocation failure, even though other
> failures return -ENOMEM or other similar values.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression ret;
> expression x,e1,e2,e3;
> @@
> 
> ret = 0
> ... when != ret = e1
> *x = \(kmalloc\|kcalloc\|kzalloc\)(...)
> ... when != ret = e2
> if (x == NULL) { ... when != ret = e3
>   return ret;
> }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  fs/ecryptfs/keystore.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 89c5476..73811cf 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -515,6 +515,7 @@ ecryptfs_write_tag_70_packet(char *dest, size_t *remaining_bytes,
>  	if (!s) {
>  		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
>  		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
> +		rc = -ENOMEM;
>  		goto out;
>  	}
>  	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> @@ -806,6 +807,7 @@ ecryptfs_parse_tag_70_packet(char **filename, size_t *filename_size,
>  	if (!s) {
>  		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
>  		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
> +		rc = -ENOMEM;
>  		goto out;
>  	}
>  	s->desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
