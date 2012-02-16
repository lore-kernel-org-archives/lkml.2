Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab2BPTN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:13:59 -0500
Received: from cobra.newdream.net ([66.33.216.30]:50385 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2BPTN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:13:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=rdmg+uLo3KTx0FZwx8X+lfcVm
	JxK3nAqmIQa2F7Mq6EeczDSc3PfiiSE1eQktZky0KqBTSMe21zgFkhGRmZwLlj52
	98OnXW8NVV2cggBtQIO3H3grOkqE61boCQa3VQiDSIOjJgjb7wJoW7Twn/WUeFvI
	LcstcJFeF7hpcObhb8=
Date: Thu, 16 Feb 2012 11:13:53 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Alex Elder <elder@dreamhost.com>
cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH 04/11] ceph: Push file_update_time() into ceph_page_mkwrite()
In-Reply-To: <1329419077.3121.38.camel@doink>
Message-ID: <Pine.LNX.4.64.1202161113001.24079@cobra.newdream.net>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
 <1329399979-3647-5-git-send-email-jack@suse.cz> <1329419077.3121.38.camel@doink>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012, Alex Elder wrote:
> On Thu, 2012-02-16 at 14:46 +0100, Jan Kara wrote:
> > CC: Sage Weil <sage@newdream.net>
> > CC: ceph-devel@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> 
> This will update the timestamp even if a write
> fault fails, which is different from before.
> 
> Hard to avoid though.
> 
> Looks good to me.

Yeah.  Let's put something in the tracker to take a look later (I think we 
can do better), but this is okay for now.

Signed-off-by: Sage Weil <sage@newdream.net>

> 
> Signed-off-by: Alex Elder <elder@dreamhost.com>
> 
> >  fs/ceph/addr.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 173b1d2..12b139f 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1181,6 +1181,9 @@ static int ceph_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	loff_t size, len;
> >  	int ret;
> >  
> > +	/* Update time before taking page lock */
> > +	file_update_time(vma->vm_file);
> > +
> >  	size = i_size_read(inode);
> >  	if (off + PAGE_CACHE_SIZE <= size)
> >  		len = PAGE_CACHE_SIZE;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
