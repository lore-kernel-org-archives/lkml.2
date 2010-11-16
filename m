Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab0KPQVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:21:21 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:18430 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754441Ab0KPQVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:21:20 -0500
Message-ID: <4CE2AF5B.7020500@draigBrady.com>
Date: Tue, 16 Nov 2010 16:20:43 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 4/6] Ext4: fail if we try to use hole punch
References: <1289840723-3056-1-git-send-email-josef@redhat.com> <1289840723-3056-5-git-send-email-josef@redhat.com>
In-Reply-To: <1289840723-3056-5-git-send-email-josef@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/11/10 17:05, Josef Bacik wrote:
> Ext4 doesn't have the ability to punch holes yet, so make sure we return
> EOPNOTSUPP if we try to use hole punching through fallocate.  This support can
> be added later.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/ext4/extents.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 0554c48..35bca73 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3622,6 +3622,10 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
>  	struct ext4_map_blocks map;
>  	unsigned int credits, blkbits = inode->i_blkbits;
>  
> +	/* We only support the FALLOC_FL_KEEP_SIZE mode */
> +	if (mode && (mode != FALLOC_FL_KEEP_SIZE))
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * currently supporting (pre)allocate mode for extent-based
>  	 * files _only_

So for older versions of ext4 or other filesystems, how do we know
that fallocate(...,FALLOC_FL_PUNCH_HOLE) is not supported.
I.E. how do we detect at runtime that the call succeeded
and didn't just do a normal fallocate()?

cheers,
Pádraig.
