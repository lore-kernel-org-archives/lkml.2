Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3AJKMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:12:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab3AJKMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:12:19 -0500
Subject: Re: [PATCH V5 26/30] gfs2: Convert aio_read/write ops to
 read/write_iter
From: Steven Whitehouse <swhiteho@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        cluster-devel@redhat.com
In-Reply-To: <1357761525-22718-27-git-send-email-dave.kleikamp@oracle.com>
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
	 <1357761525-22718-27-git-send-email-dave.kleikamp@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 10 Jan 2013 10:10:55 +0000
Message-ID: <1357812655.2760.9.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2013-01-09 at 13:58 -0600, Dave Kleikamp wrote:
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> ---
>  fs/gfs2/file.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index 991ab2d..63af1a6 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -655,10 +655,9 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
>  }
>  
>  /**
> - * gfs2_file_aio_write - Perform a write to a file
> + * gfs2_file_write_iter - Perform a write to a file
>   * @iocb: The io context
> - * @iov: The data to write
> - * @nr_segs: Number of @iov segments
> + * @iter: The data to write
>   * @pos: The file position
>   *
>   * We have to do a lock/unlock here to refresh the inode size for
> @@ -668,11 +667,11 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
>   *
>   */
>  
> -static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
> -				   unsigned long nr_segs, loff_t pos)
> +static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
> +				    loff_t pos)
>  {
>  	struct file *file = iocb->ki_filp;
> -	size_t writesize = iov_length(iov, nr_segs);
> +	size_t writesize = iov_iter_count(iter);

Hmm, I had a vague memory that we'd agreed to call this iov_iter_length
rather than iov_iter_count in order to keep the existing naming and to
make it sound more like what it is (the length of the data) as opposed
to the number of individual buffers to be written.

Not that it is desperately important, but just to flag it up in case it
got forgotten at some stage,

Steve.


