Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2BPTEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:04:49 -0500
Received: from mail.hq.newdream.net ([66.33.206.127]:57351 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2BPTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=dreamhost.com; h=message-id
	:subject:from:reply-to:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; q=dns; s=
	dreamhost.com; b=dkpYqgnHDgiYEpwpcQA0SF1SjSz39azyMsMKcSyuANrLj1H
	bEMph+2QZpbdS9PVxD4YZBeRkzmaux0b7kKq/DW0yr6DPRkv+cNrubsmjkoZziql
	MOLlHOGHesDECZPSuK6dcaXN/Xi9V9hZesBg2NLmmdzFinw6zi4ZGTvCi7EQ=
Message-ID: <1329419084.3121.39.camel@doink>
Subject: Re: [PATCH 09/11] sysfs: Push file_update_time() into
 bin_page_mkwrite()
From: Alex Elder <elder@dreamhost.com>
Reply-To: elder@dreamhost.com
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 16 Feb 2012 13:04:44 -0600
In-Reply-To: <1329399979-3647-10-git-send-email-jack@suse.cz>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
	 <1329399979-3647-10-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 14:46 +0100, Jan Kara wrote:
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/sysfs/bin.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
> index a475983..6ceb16f 100644
> --- a/fs/sysfs/bin.c
> +++ b/fs/sysfs/bin.c
> @@ -225,6 +225,8 @@ static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (!sysfs_get_active(attr_sd))
>  		return VM_FAULT_SIGBUS;
>  
> +	file_update_time(file);
> +
>  	ret = 0;
>  	if (bb->vm_ops->page_mkwrite)
>  		ret = bb->vm_ops->page_mkwrite(vma, vmf);

If the filesystem's page_mkwrite() function is responsible
for updating the time, can't the call to file_update_time()
here be conditional?

I.e:
	ret = 0;
	if (bb->vm_ops->page_mkwrite)
 		ret = bb->vm_ops->page_mkwrite(vma, vmf);
	else
		file_update_time(file);

					-Alex




