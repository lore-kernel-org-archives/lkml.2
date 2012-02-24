Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2BXRK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:10:27 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40519 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab2BXRKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:10:25 -0500
References: <4f468ef2.4105440a.56cc.ffffa1d7@mx.google.com>
In-Reply-To: <4f468ef2.4105440a.56cc.ffffa1d7@mx.google.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <8AC30AEF-F9A3-4CD2-B2C0-398A87ABD20F@gmail.com>
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>, "adilger@dilger.ca" <adilger@dilger.ca>,
        "andrew_perepechko@xyratex.com" <andrew_perepechko@xyratex.com>,
        "nikitas_angelinas@xyratex.com" <nikitas_angelinas@xyratex.com>,
        "johann@whamcloud.com" <johann@whamcloud.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Santosh Nayak <santoshprasadnayak@gmail.com>
X-Mailer: iPhone Mail (9A405)
From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] ext4: MMP: Fix endianness bug.
Date: Fri, 24 Feb 2012 10:10:50 -0700
To: "santoshprasadnayak@gmail.com" <santoshprasadnayak@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-23, at 12:09, santoshprasadnayak@gmail.com wrote:

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Sparse complaint this endian bug in ext4: mmp.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>

Looks good. 

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/mmp.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 7ea4ba4..ed6548d 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -257,8 +257,8 @@ int ext4_multi_mount_protect(struct super_block *sb,
>     * If check_interval in MMP block is larger, use that instead of
>     * update_interval from the superblock.
>     */
> -    if (mmp->mmp_check_interval > mmp_check_interval)
> -        mmp_check_interval = mmp->mmp_check_interval;
> +    if (le16_to_cpu(mmp->mmp_check_interval) > mmp_check_interval)
> +        mmp_check_interval = le16_to_cpu(mmp->mmp_check_interval);
> 
>    seq = le32_to_cpu(mmp->mmp_seq);
>    if (seq == EXT4_MMP_SEQ_CLEAN)
> -- 
> 1.7.4.4
> 
