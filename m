Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2GWT1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:27:03 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57828 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754354Ab2GWT1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:27:00 -0400
Message-ID: <500DA581.1020602@sgi.com>
Date: Mon, 23 Jul 2012 14:26:57 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Nick Piggin <npiggin@gmail.com>, Hugh Dickins <hughd@google.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2 v5][resend] tmpfs: interleave the starting node of
 /dev/shmem
References: <1341845199-25677-1-git-send-email-nzimmer@sgi.com> <1341845199-25677-2-git-send-email-nzimmer@sgi.com> <1341845199-25677-3-git-send-email-nzimmer@sgi.com> <20120723105819.GA4455@mwanda>
In-Reply-To: <20120723105819.GA4455@mwanda>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.162.233.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes I had failed to notice that.
I'll send a fix shortly.


On 07/23/2012 05:58 AM, Dan Carpenter wrote:
> On Mon, Jul 09, 2012 at 09:46:39AM -0500, Nathan Zimmer wrote:
>> +static unsigned long shmem_interleave(struct vm_area_struct *vma,
>> +					unsigned long addr)
>> +{
>> +	unsigned long offset;
>> +
>> +	/* Use the vm_files prefered node as the initial offset. */
>> +	offset = (unsigned long *) vma->vm_private_data;
> Should this be?:
> 	offset = (unsigned long)vma->vm_private_data;
>
> offset is an unsigned long, not a pointer.  ->vm_private_data is a
> void pointer.
>
> It causes a GCC warning:
> mm/shmem.c: In function ‘shmem_interleave’:
> mm/shmem.c:1341:9: warning: assignment makes integer from pointer without a cast [enabled by default]
>
>> +
>> +	offset += ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
>> +
>> +	return offset;
>> +}
>>   #endif
> regards,
> dan carpenter
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

