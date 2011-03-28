Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1C1Vda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:33:30 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:58275 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1C1Vd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:33:29 -0400
Date: Mon, 28 Mar 2011 23:33:26 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] uio: fix finding mm index for vma
Message-ID: <20110328213325.GB2786@local>
References: <AANLkTim3jJi4ZMZHGztyS==wCJ5C-tLbRe99Qj0YnDe3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim3jJi4ZMZHGztyS==wCJ5C-tLbRe99Qj0YnDe3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 03:58:19PM +0800, Hillf Danton wrote:

(Added Greg KH to Cc:)

Please Cc: Greg and me when posting patches for UIO.

> When finding mm index for vma it looks more flexible that the mm could
> be sparse, and
> both the size of mm and the pgoff of vma could give correct selection.

Nice improvement!

Thanks for your contribution,
Hans

> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>

> ---
> 
> --- a/drivers/uio/uio.c	2011-01-05 08:50:20.000000000 +0800
> +++ b/drivers/uio/uio.c	2011-03-27 14:33:02.000000000 +0800
> @@ -587,14 +587,12 @@ static ssize_t uio_write(struct file *fi
> 
>  static int uio_find_mem_index(struct vm_area_struct *vma)
>  {
> -	int mi;
>  	struct uio_device *idev = vma->vm_private_data;
> 
> -	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
> -		if (idev->info->mem[mi].size == 0)
> +	if (vma->vm_pgoff < MAX_UIO_MAPS) {
> +		if (idev->info->mem[vma->vm_pgoff].size == 0)
>  			return -1;
> -		if (vma->vm_pgoff == mi)
> -			return mi;
> +		return (int)vma->vm_pgoff;
>  	}
>  	return -1;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
