Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1LFFwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 00:52:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62206 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab1LFFwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 00:52:02 -0500
Message-ID: <4EDDAD46.6020508@cn.fujitsu.com>
Date: Tue, 06 Dec 2011 13:51:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        viro <viro@zeniv.linux.org.uk>, Chris Mason <chris.mason@oracle.com>,
        Ito <t-itoh@jp.fujitsu.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/2] vfs: make writeback_in_progress() inline
References: <4EDDA9B1.5050000@cn.fujitsu.com>
In-Reply-To: <4EDDA9B1.5050000@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-06 13:51:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-06 13:51:33,
	Serialize complete at 2011-12-06 13:51:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc Fengguang
cc Linux-kernel

On tue, 06 Dec 2011 13:35:45 +0800, Miao Xie wrote:
> writeback_in_progress() is very simple, and we will use writeback_in_progress()
> in the module, so make it inline.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/fs-writeback.c           |   12 ------------
>  include/linux/backing-dev.h |   12 +++++++++++-
>  2 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 04cf3b9..341448c 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -59,18 +59,6 @@ struct wb_writeback_work {
>   */
>  int nr_pdflush_threads;
>  
> -/**
> - * writeback_in_progress - determine whether there is writeback in progress
> - * @bdi: the device's backing_dev_info structure.
> - *
> - * Determine whether there is writeback waiting to be handled against a
> - * backing device.
> - */
> -int writeback_in_progress(struct backing_dev_info *bdi)
> -{
> -	return test_bit(BDI_writeback_running, &bdi->state);
> -}
> -
>  static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
>  {
>  	struct super_block *sb = inode->i_sb;
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 3b2f9cb..ae4d7c0 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -258,7 +258,17 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
>  extern struct backing_dev_info default_backing_dev_info;
>  extern struct backing_dev_info noop_backing_dev_info;
>  
> -int writeback_in_progress(struct backing_dev_info *bdi);
> +/**
> + * writeback_in_progress - determine whether there is writeback in progress
> + * @bdi: the device's backing_dev_info structure.
> + *
> + * Determine whether there is writeback waiting to be handled against a
> + * backing device.
> + */
> +static inline int writeback_in_progress(struct backing_dev_info *bdi)
> +{
> +	return test_bit(BDI_writeback_running, &bdi->state);
> +}
>  
>  static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
>  {

