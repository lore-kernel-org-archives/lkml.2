Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1KGPDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:03:49 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45595 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1KGPDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:03:47 -0500
Message-ID: <4EB7F349.6080903@linux.vnet.ibm.com>
Date: Mon, 07 Nov 2011 20:33:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: tytso@mit.edu, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference from orig_data
 in fill_super and remount.
References: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11110705-1396-0000-0000-000000294635
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 07:31 PM, Namjae Jeon wrote:
> Fix NULL pointer dereference from orig_data in fill_super and remount.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

> ---
>  fs/ext4/super.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 9953d80..717b3e8 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3102,7 +3102,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  				__releases(kernel_lock)
>  				__acquires(kernel_lock)
>  {
> -	char *orig_data = kstrdup(data, GFP_KERNEL);
>  	struct buffer_head *bh;
>  	struct ext4_super_block *es = NULL;
>  	struct ext4_sb_info *sbi;
> @@ -3125,6 +3124,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
>  	ext4_group_t first_not_zeroed;
> 
> +	char *orig_data = kstrdup(data, GFP_KERNEL);
> +	if (!orig_data)
> +		return ret;
> +
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
>  	if (!sbi)
>  		goto out_free_orig;
> @@ -4398,6 +4401,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  	int i;
>  #endif
>  	char *orig_data = kstrdup(data, GFP_KERNEL);
> +	if (!orig_data)
> +		return -ENOMEM;
> 
>  	/* Store the original options */
>  	lock_super(sb);

