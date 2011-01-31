Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab1AaM3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:29:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1AaM3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:29:37 -0500
Date: Mon, 31 Jan 2011 07:29:27 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
Message-ID: <20110131072927.75a11bc5@tlielax.poochiereds.net>
In-Reply-To: <4D4693CF.9090903@suse.de>
References: <20110131133038.ab3aa826.sfr@canb.auug.org.au>
	<4D4693CF.9090903@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 16:19:51 +0530
Suresh Jayaraman <sjayaraman@suse.de> wrote:

> On 01/31/2011 08:00 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the cifs tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> > 
> > fs/cifs/file.c: In function 'cifs_iovec_write':
> > fs/cifs/file.c:1740: warning: passing argument 6 of 'CIFSSMBWrite2' from incompatible pointer type
> > fs/cifs/cifsproto.h:343: note: expected 'unsigned int *' but argument is of type 'size_t *'
> > 
> > Introduced by commit 72432ffcf555decbbae47f1be338e1d2f210aa69 ("CIFS:
> > Implement cifs_strict_writev (try #4)").
> > 
> 
> The following patch should silence that warning.
> 
> From: Suresh Jayaraman <sjayaraman@suse.de>
> Subject: [PATCH] cifs: fix compiler warning about incompatible pointer type
> 
> fs/cifs/file.c: In function ‘cifs_iovec_write’:
> fs/cifs/file.c:1740:9: warning: passing argument 6 of ‘CIFSSMBWrite2’ from incompatible pointer type
> fs/cifs/cifsproto.h:343:12: note: expected ‘unsigned int *’ but argument is of type ‘size_t *’
> 
> Cc: Pavel Shilovsky <piastryyy@gmail.com>
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> ---
>  fs/cifs/file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0de17c1..2a3c5d8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1667,7 +1667,7 @@ static ssize_t
>  cifs_iovec_write(struct file *file, const struct iovec *iov,
>  		 unsigned long nr_segs, loff_t *poffset)
>  {
> -	size_t total_written = 0, written = 0;
> +	unsigned int total_written = 0, written = 0;
>  	unsigned long num_pages, npages;
>  	size_t copied, len, cur_len, i;
>  	struct kvec *to_send;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I fixed this a few days ago along with a number of other compiler
warnings in:

    [PATCH] cifs: clean up some compiler warnings

...just waiting for Steve to merge it.

-- 
Jeff Layton <jlayton@redhat.com>
