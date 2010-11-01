Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab0KAT0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:26:53 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20961 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0KAT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:26:52 -0400
Date: Mon, 1 Nov 2010 20:16:19 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tracey Dent <tdent48227@gmail.com>
cc: greg@kroah.com, manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 24/29] Staging: yaffs2: yaffs_verify: Add files
In-Reply-To: <1288636877-7964-25-git-send-email-tdent48227@gmail.com>
Message-ID: <alpine.LNX.2.00.1011012008351.12889@swampdragon.chaosbits.net>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com> <1288636877-7964-25-git-send-email-tdent48227@gmail.com>
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
>  drivers/staging/yaffs2/yaffs_verify.c |  631 +++++++++++++++++++++++++++++++++
>  drivers/staging/yaffs2/yaffs_verify.h |   41 +++
>  2 files changed, 672 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/yaffs2/yaffs_verify.c
>  create mode 100644 drivers/staging/yaffs2/yaffs_verify.h
> 
> diff --git a/drivers/staging/yaffs2/yaffs_verify.c b/drivers/staging/yaffs2/yaffs_verify.c
> new file mode 100644
> index 0000000..89e730b
> --- /dev/null
> +++ b/drivers/staging/yaffs2/yaffs_verify.c
...
> +#if 0

Why are you trying to merge new code that's under '#if 0' (and not just 
here, but elsewhere as well)?
Either it shouldn't be here, in which case it should just be omitted from 
the patch, or it needs to be here eventually in which case it should be 
fixed up so the '#if 0' can go away or simply just be added later when it 
has been fixed up.

 > +/* Not being used, but don't want to throw away yet 
*/ > +int yaffs_verify_tnode_worker(yaffs_obj_t *obj, yaffs_tnode_t *tn,
> +					__u32 level, int chunk_offset)
> +{
> +	int i;
> +	yaffs_dev_t *dev = obj->my_dev;
> +	int ok = 1;
> +
> +	if (tn) {
> +		if (level > 0) {
> +
> +			for (i = 0; i < YAFFS_NTNODES_INTERNAL && ok; i++) {
> +				if (tn->internal[i]) {
> +					ok = yaffs_verify_tnode_worker(obj,
> +							tn->internal[i],
> +							level - 1,
> +							(chunk_offset<<YAFFS_TNODES_INTERNAL_BITS) + i);
> +				}
> +			}
> +		} else if (level == 0) {
> +			yaffs_ext_tags tags;
> +			__u32 obj_id = obj->obj_id;
> +
> +			chunk_offset <<=  YAFFS_TNODES_LEVEL0_BITS;
> +
> +			for (i = 0; i < YAFFS_NTNODES_LEVEL0; i++) {
> +				__u32 the_chunk = yaffs_get_group_base(dev, tn, i);
> +
> +				if (the_chunk > 0) {
> +					/* T(~0,(TSTR("verifying (%d:%d) %d"TENDSTR),tags.obj_id,tags.chunk_id,the_chunk)); */
> +					yaffs_rd_chunk_tags_nand(dev, the_chunk, NULL, &tags);
> +					if (tags.obj_id != obj_id || tags.chunk_id != chunk_offset) {
> +						T(~0, (TSTR("Object %d chunk_id %d NAND mismatch chunk %d tags (%d:%d)"TENDSTR),
> +							obj_id, chunk_offset, the_chunk,
> +							tags.obj_id, tags.chunk_id));
> +					}
> +				}
> +				chunk_offset++;
> +			}
> +		}
> +	}
> +
> +	return ok;

Here I think it would be nice to reduce the indentation level a bit by by 
doing something like:

int yaffs_verify_tnode_worker(yaffs_obj_t *obj, yaffs_tnode_t *tn,
                                     __u32 level, int chunk_offset)
{
     int i;
     yaffs_dev_t *dev = obj->my_dev;
     int ok = 1;
                     
     if (!tn)
          goto out; /* or simply  return ok;  */

     ... all the stuff currently inside the if() ...

 out:
     return ok;
}


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

