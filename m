Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1HTBrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 21:47:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55273 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1HTBq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 21:46:58 -0400
Message-ID: <4E4F11DA.5050209@cn.fujitsu.com>
Date: Sat, 20 Aug 2011 09:46:02 +0800
From: liubo <liubo2009@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
CC: linux-btrfs@vger.kernel.org, chris.mason@oracle.com, dave@jikos.cz
Subject: Re: [PATCH] Btrfs: use do_div to avoid compile errors on 32bit box
References: <1313804076-30228-1-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1313804076-30228-1-git-send-email-liubo2009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-20 09:45:27,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-20 09:45:27,
	Serialize complete at 2011-08-20 09:45:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2011 09:34 AM, Liu Bo wrote:
> When doing div operation of u64 type, we need to be careful and use do_div
> to avoid compile ERROR on 32bit box:
> 
> "ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 

Sorry, guys, I just sent a wrong version.

Plz ignore this one.  I'm sorry.

thanks,
liubo

> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 80d6148..9b495ce 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6796,14 +6796,14 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>  	index = get_block_group_index(block_group);
>  	if (index == 0) {
>  		dev_min = 4;
> -		min_free /= 2;
> +		do_div(min_free, 2);
>  	} else if (index == 1) {
>  		dev_min = 2;
>  	} else if (index == 2) {
>  		min_free *= 2;
>  	} else if (index == 3) {
>  		dev_min = fs_devices->rw_devices;
> -		min_free /= dev_min;
> +		do_div(min_free, dev_min);
>  	}
>  
>  	mutex_lock(&root->fs_info->chunk_mutex);

