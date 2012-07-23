Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2GWK7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 06:59:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41146 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2GWK7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 06:59:03 -0400
Date: Mon, 23 Jul 2012 13:58:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Nick Piggin <npiggin@gmail.com>, Hugh Dickins <hughd@google.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2 v5][resend] tmpfs: interleave the starting node of
 /dev/shmem
Message-ID: <20120723105819.GA4455@mwanda>
References: <1341845199-25677-1-git-send-email-nzimmer@sgi.com>
 <1341845199-25677-2-git-send-email-nzimmer@sgi.com>
 <1341845199-25677-3-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1341845199-25677-3-git-send-email-nzimmer@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 09:46:39AM -0500, Nathan Zimmer wrote:
> +static unsigned long shmem_interleave(struct vm_area_struct *vma,
> +					unsigned long addr)
> +{
> +	unsigned long offset;
> +
> +	/* Use the vm_files prefered node as the initial offset. */
> +	offset = (unsigned long *) vma->vm_private_data;

Should this be?:
	offset = (unsigned long)vma->vm_private_data;

offset is an unsigned long, not a pointer.  ->vm_private_data is a
void pointer.

It causes a GCC warning:
mm/shmem.c: In function ‘shmem_interleave’:
mm/shmem.c:1341:9: warning: assignment makes integer from pointer without a cast [enabled by default]

> +
> +	offset += ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> +
> +	return offset;
> +}
>  #endif

regards,
dan carpenter
