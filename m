Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab1JCJYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:24:45 -0400
Received: from natasha.panasas.com ([67.152.220.90]:54037 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1JCJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:24:40 -0400
Message-ID: <4E897F4E.5010703@panasas.com>
Date: Mon, 3 Oct 2011 11:24:30 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <osd-dev@open-osd.org>,
        <bhalevy@panasas.com>
Subject: Re: [PATCH] exofs/super.c: local functions should be static
References: <201109231346.51759.hartleys@visionengravers.com>
In-Reply-To: <201109231346.51759.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 11:46 PM, H Hartley Sweeten wrote:
> This quiets the following sparse noise:
> 
> warning: symbol 'exofs_sync_fs' was not declared. Should it be static?
> warning: symbol 'exofs_free_sbi' was not declared. Should it be static?
> warning: symbol 'exofs_get_parent' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: Benny Halevy <bhalevy@panasas.com>
> 

Both patches are in linux-next for the next merge window

Thanks Hartley
Boaz

> ---
> 
> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
> index 9049e27..8c900d4 100644
> --- a/fs/exofs/super.c
> +++ b/fs/exofs/super.c
> @@ -356,7 +356,7 @@ static const struct export_operations exofs_export_ops;
>  /*
>   * Write the superblock to the OSD
>   */
> -int exofs_sync_fs(struct super_block *sb, int wait)
> +static int exofs_sync_fs(struct super_block *sb, int wait)
>  {
>  	struct exofs_sb_info *sbi;
>  	struct exofs_fscb *fscb;
> @@ -430,7 +430,7 @@ static void _exofs_print_device(const char *msg, const char *dev_path,
>  		msg, dev_path ?: "", odi->osdname, _LLU(pid));
>  }
>  
> -void exofs_free_sbi(struct exofs_sb_info *sbi)
> +static void exofs_free_sbi(struct exofs_sb_info *sbi)
>  {
>  	while (sbi->comps.numdevs) {
>  		int i = --sbi->comps.numdevs;
> @@ -969,7 +969,7 @@ static const struct super_operations exofs_sops = {
>   * EXPORT OPERATIONS
>   *****************************************************************************/
>  
> -struct dentry *exofs_get_parent(struct dentry *child)
> +static struct dentry *exofs_get_parent(struct dentry *child)
>  {
>  	unsigned long ino = exofs_parent_ino(child);
>  

