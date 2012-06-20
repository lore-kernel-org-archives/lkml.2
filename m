Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2FTV5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 17:57:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157Ab2FTV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 17:57:00 -0400
Date: Wed, 20 Jun 2012 14:56:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Bret Towe <magnade@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, mfasheh@suse.com, jlbec@evilplan.org,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: BUG in ofcs2_change_file_space
Message-Id: <20120620145659.a5fff5f6.akpm@linux-foundation.org>
In-Reply-To: <87bokddfr9.fsf@canonical.com>
References: <CALjC5haTNDMOTDPL1m1uBTc2a-Qb8cvR44SCaVDFMzGc+Gw3+w@mail.gmail.com>
	<CALjC5hac=Wh_8J0qn0MCo6qXRtjQf1R-8jn79hMma0Qghg7jSQ@mail.gmail.com>
	<CALjC5hZBizcq0DwP=yX0z=_G3MibD2Ztjid2U86ez5YyZZRkYQ@mail.gmail.com>
	<87bokddfr9.fsf@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 19:01:30 +0100
Luis Henriques <luis.henriques@canonical.com> wrote:

> >> a patch has been available for this for a while now
> >> found here: http://oss.oracle.com/pipermail/ocfs2-devel/2012-January/008464.html
> >> but it still has not hit mainline
> >> is there any way we can get this included?
> 
> I believe something like this would be more appropriated, as a NULL as the
> 'file' parameter seems to be valid in that context:
> 
> ---
>  fs/ocfs2/file.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 6e39668..84822a4 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1950,7 +1950,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>  	if (ret < 0)
>  		mlog_errno(ret);
>  
> -	if (file->f_flags & O_SYNC)
> +	if (file && (file->f_flags & O_SYNC))
>  		handle->h_sync = 1;
>  
>  	ocfs2_commit_trans(osb, handle);

Sunil, does this look OK to you?  And Bret, can you please test it?

Luis, can you please prepare a proper, signed-off, changelogged version
of this and I'll grab it, thanks.


I'm not seeing any OCFS2 activity in mainline from Joel and Mark in six
months, so I'm getting those i-have-a-new-subsystem-to-maintain
feelings.

If anyone else has any urgent OCFS2 patches then please resend them, cc
myself and cc linux-kernel.

