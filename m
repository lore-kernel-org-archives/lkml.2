Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1LAHj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:39:28 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:52066 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751780Ab1LAHj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:39:26 -0500
Message-ID: <4ED72F1D.7070207@tao.ma>
Date: Thu, 01 Dec 2011 15:39:09 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Set the initial TRIM information as TRIMMED
References: <20111201070052.GA29708@july>
In-Reply-To: <20111201070052.GA29708@july>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,
On 12/01/2011 03:00 PM, Kyungmin Park wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Now trim information doesn't stored at disk so every boot time. it's cleared.
> and do the trim all disk groups.
> But assume that it's already trimmed at previous time so don't need to trim it again. So set the intial state as trimmed.
sorry, I don't get your meaning here.
Why can we assume that the group is already trimmed since it isn't
stored in the disk?

Thanks
Tao
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2d8be8..97ef342 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1098,6 +1098,12 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
>  		goto err;
>  	}
>  	mark_page_accessed(page);
> +
> +	/*
> +	 * TRIM information is not stored at disk so set the initial
> +	 * state as trimmed. Since previous time it's already trimmed all
> +	 */
> +	EXT4_MB_GRP_SET_TRIMMED(this_grp);
>  err:
>  	ext4_mb_put_buddy_page_lock(&e4b);
>  	return ret;

