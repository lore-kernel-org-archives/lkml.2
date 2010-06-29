Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0F2A4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 20:56:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61295 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab0F2A4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 20:56:01 -0400
Message-ID: <4C294512.8070302@cn.fujitsu.com>
Date: Tue, 29 Jun 2010 08:57:54 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Chris Mason <chris.mason@oracle.com>,
       Yan Zheng <zheng.yan@oracle.com>, Diego Calleja <diegocg@gmail.com>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] btrfs: make code reachable in btrfs_insert_some_items()
References: <20100628111726.GI19184@bicker>
In-Reply-To: <20100628111726.GI19184@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on 2010-6-28 19:17, Dan Carpenter wrote:
> The break was in front of the "nr = i" assignment so that was never hit.

This bug has been fixed a month ago, and the patch has been merged into the
btrfs-unstable tree.

  http://marc.info/?l=linux-btrfs&m=127434036913484&w=2

Thanks
Miao
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 0d1d966..ceb8ad2 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3453,8 +3453,8 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
>  	for (i = 0; i < nr; i++) {
>  		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
>  		    BTRFS_LEAF_DATA_SIZE(root)) {
> -			break;
>  			nr = i;
> +			break;
>  		}
>  		total_data += data_size[i];
>  		total_size += data_size[i] + sizeof(struct btrfs_item);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


