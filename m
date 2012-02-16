Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2BPTEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:04:43 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:57336 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2BPTEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:04:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=dreamhost.com; h=message-id
	:subject:from:reply-to:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; q=dns; s=
	dreamhost.com; b=Ef9xuXgBouIVaIF2iBBuW0HScVjqiw6zBVSZmA8FT92JEYs
	pw+HsL/6I8mMcuUThrY11uJmGP+dX3EvSYTqnjMFNxtdHPvo4/NCWR9eUV43ILea
	KEMR031mBhw8ieYxn8BDvrGtndDH0Ns5jUZErb9sXEBKPN94kIl9ru8JLSPk=
Message-ID: <1329419077.3121.38.camel@doink>
Subject: Re: [PATCH 04/11] ceph: Push file_update_time() into
 ceph_page_mkwrite()
From: Alex Elder <elder@dreamhost.com>
Reply-To: elder@dreamhost.com
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org
Date: Thu, 16 Feb 2012 13:04:37 -0600
In-Reply-To: <1329399979-3647-5-git-send-email-jack@suse.cz>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
	 <1329399979-3647-5-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 14:46 +0100, Jan Kara wrote:
> CC: Sage Weil <sage@newdream.net>
> CC: ceph-devel@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>


This will update the timestamp even if a write
fault fails, which is different from before.

Hard to avoid though.

Looks good to me.

Signed-off-by: Alex Elder <elder@dreamhost.com>

>  fs/ceph/addr.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 173b1d2..12b139f 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1181,6 +1181,9 @@ static int ceph_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	loff_t size, len;
>  	int ret;
>  
> +	/* Update time before taking page lock */
> +	file_update_time(vma->vm_file);
> +
>  	size = i_size_read(inode);
>  	if (off + PAGE_CACHE_SIZE <= size)
>  		len = PAGE_CACHE_SIZE;



