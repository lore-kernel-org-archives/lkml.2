Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2BPNun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:50:43 -0500
Received: from mx2.netapp.com ([216.240.18.37]:39475 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab2BPNul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:50:41 -0500
X-IronPort-AV: E=Sophos;i="4.73,429,1325491200"; 
   d="scan'208";a="625943512"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 10/11] nfs: Push file_update_time() into
 nfs_vm_page_mkwrite()
Thread-Topic: [PATCH 10/11] nfs: Push file_update_time() into
 nfs_vm_page_mkwrite()
Thread-Index: AQHM7LF4HLjr0f5zZkqq+Nw6/NJ0fJZAEJCA
Date: Thu, 16 Feb 2012 13:50:19 +0000
Message-ID: <1329400219.2924.1.camel@lade.trondhjem.org>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
	 <1329399979-3647-11-git-send-email-jack@suse.cz>
In-Reply-To: <1329399979-3647-11-git-send-email-jack@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8ABF0572E4E5541A2B4351FE359100D@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Feb 2012 13:50:21.0373 (UTC) FILETIME=[ECD636D0:01CCECB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1GDolV7024008

On Thu, 2012-02-16 at 14:46 +0100, Jan Kara wrote:
> CC: Trond Myklebust <Trond.Myklebust@netapp.com>
> CC: linux-nfs@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/nfs/file.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index c43a452..2407922 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -525,6 +525,9 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	/* make sure the cache has finished storing the page */
>  	nfs_fscache_wait_on_page_write(NFS_I(dentry->d_inode), page);
>  
> +	/* Update file times before taking page lock */
> +	file_update_time(filp);
> +
>  	lock_page(page);
>  	mapping = page->mapping;
>  	if (mapping != dentry->d_inode->i_mapping)

Hi Jan,

file_update_time() is a no-op in NFS, since we set S_NOATIME|S_NOCMTIME
on all inodes.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
