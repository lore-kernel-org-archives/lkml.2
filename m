Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0KAVUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:20:21 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22853 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab0KAVUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:20:17 -0400
Date: Mon, 1 Nov 2010 22:09:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tracey Dent <tdent48227@gmail.com>
cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/29] Staging: yaffs2: yaffs_checkptrw: Add files
In-Reply-To: <1288636877-7964-8-git-send-email-tdent48227@gmail.com>
Message-ID: <alpine.LNX.2.00.1011012157490.12889@swampdragon.chaosbits.net>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <1288636877-7964-8-git-send-email-tdent48227@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Tracey Dent wrote:

> Adding files to yaffs2 directory.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/yaffs2/yaffs_checkptrw.c |  400 ++++++++++++++++++++++++++++++
>  drivers/staging/yaffs2/yaffs_checkptrw.h |   34 +++
>  2 files changed, 434 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_checkptrw.c
>  create mode 100644 drivers/staging/yaffs2/yaffs_checkptrw.h
> 
> diff --git a/drivers/staging/yaffs2/yaffs_checkptrw.c b/drivers/staging/yaffs2/yaffs_checkptrw.c
> new file mode 100644
> index 0000000..82d6874
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yaffs_checkptrw.c
[snip]
> +static void yaffs2_checkpt_find_erased_block(yaffs_dev_t *dev)
> +{
> +	int  i;
> +	int blocks_avail = dev->n_erased_blocks - dev->param.n_reserved_blocks;
> +	T(YAFFS_TRACE_CHECKPOINT,
> +		(TSTR("allocating checkpt block: erased %d reserved %d avail %d next %d "TENDSTR),
> +		dev->n_erased_blocks, dev->param.n_reserved_blocks, blocks_avail, dev->checkpt_next_block));
> +
> +	if (dev->checkpt_next_block >= 0 &&
> +			dev->checkpt_next_block <= dev->internal_end_block &&
> +			blocks_avail > 0) {
> +

Ok, perhaps I've been writing C++ apps in userspace too much, but on first 
impulse I'd say that the 'i' variable should be declared here in this 
scope where it's first used and not in global function scope.

> +		for (i = dev->checkpt_next_block; i <= dev->internal_end_block; i++) {

[snip]
> +static void yaffs2_checkpt_find_block(yaffs_dev_t *dev)
> +{
> +	int  i;
> +	yaffs_ext_tags tags;
> +
> +	T(YAFFS_TRACE_CHECKPOINT, (TSTR("find next checkpt block: start:  blocks %d next %d" TENDSTR),
> +		dev->blocks_in_checkpt, dev->checkpt_next_block));
> +
> +	if (dev->blocks_in_checkpt < dev->checkpt_max_blocks)

same here.

> +		for (i = dev->checkpt_next_block; i <= dev->internal_end_block; i++) {


[snip]
> +int yaffs2_checkpt_open(yaffs_dev_t *dev, int writing)
> +{
> +
> +

Small thing, but I've seen this a lot in these patches - double blank 
lines (or more) where either a single one or zero would do just as well 
(or actually better).

It's a small thing, but the number of (relevant) code lines visible on the 
screen at once actually matters. Sure, a blank line between blocks often 
makes sense in order to visually seperate one block of code from another, 
but two (or more) lines often don't serve a purpose except prevent more 
relevant stuff to being visible - especially in cases like this where it's 
at the start of a function, I really don't see the point.


> +int yaffs2_get_checkpt_sum(yaffs_dev_t *dev, __u32 *sum)
> +{
> +	__u32 composite_sum;
> +	composite_sum =  (dev->checkpt_sum << 8) | (dev->checkpt_xor & 0xFF);
> +	*sum = composite_sum;
> +	return 1;
> +}

Why not

int yaffs2_get_checkpt_sum(yaffs_dev_t *dev, __u32 *sum)
{
     *sum  = (dev->checkpt_sum << 8) | (dev->checkpt_xor & 0xFF);
     return 1;
}

???


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

