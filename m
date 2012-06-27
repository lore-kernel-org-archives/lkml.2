Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2F0Pwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:52:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab2F0Pwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:52:32 -0400
Date: Wed, 27 Jun 2012 17:52:30 +0200
From: Jan Kara <jack@suse.cz>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Ashish Sangwan <ashish.sangwan2@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH] UDF: Remove unnecessary variable "offset" from
 udf_fill_inode
Message-ID: <20120627155230.GA5387@quack.suse.cz>
References: <1340719391-3081-1-git-send-email-ashish.sangwan2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340719391-3081-1-git-send-email-ashish.sangwan2@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-06-12 19:33:11, Ashish Sangwan wrote:
> The variable "offset" is not needed. Remove it.
  Thanks. Merged.

								Honza

> 
> Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  fs/udf/inode.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 873e1ba..fafaad7 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1247,7 +1247,6 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  {
>  	struct fileEntry *fe;
>  	struct extendedFileEntry *efe;
> -	int offset;
>  	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
>  	struct udf_inode_info *iinfo = UDF_I(inode);
>  	unsigned int link_count;
> @@ -1359,7 +1358,6 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  		iinfo->i_lenEAttr = le32_to_cpu(fe->lengthExtendedAttr);
>  		iinfo->i_lenAlloc = le32_to_cpu(fe->lengthAllocDescs);
>  		iinfo->i_checkpoint = le32_to_cpu(fe->checkpoint);
> -		offset = sizeof(struct fileEntry) + iinfo->i_lenEAttr;
>  	} else {
>  		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
>  		    (inode->i_sb->s_blocksize_bits - 9);
> @@ -1381,8 +1379,6 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  		iinfo->i_lenEAttr = le32_to_cpu(efe->lengthExtendedAttr);
>  		iinfo->i_lenAlloc = le32_to_cpu(efe->lengthAllocDescs);
>  		iinfo->i_checkpoint = le32_to_cpu(efe->checkpoint);
> -		offset = sizeof(struct extendedFileEntry) +
> -							iinfo->i_lenEAttr;
>  	}
>  
>  	switch (fe->icbTag.fileType) {
> -- 
> 1.7.2.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
