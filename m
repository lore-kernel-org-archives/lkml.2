Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1AFXll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:41:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab1AFXlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:41:40 -0500
Date: Thu, 6 Jan 2011 15:41:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rlandley@parallels.com>
Cc: <trivial@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] Move an assert under DEBUG_KERNEL.
Message-Id: <20110106154120.b69118c9.akpm@linux-foundation.org>
In-Reply-To: <4D2579B2.7060704@parallels.com>
References: <4D2579B2.7060704@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 02:13:38 -0600
Rob Landley <rlandley@parallels.com> wrote:

> From: Rob Landley <rlandley@parallels.com>
> 
> Move an assert under DEBUG_KERNEL.
> 
> Signed-off-by: Rob Landley <rlandley@parallels.com>
> ---
> 
> Saves about 3k from x86-64 defconfig according to scripts/bloat-o-meter.
> 
>   include/linux/rtnetlink.h |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
> index bbad657..28c4025 100644
> --- a/include/linux/rtnetlink.h
> +++ b/include/linux/rtnetlink.h
> @@ -782,6 +782,7 @@ extern struct netdev_queue 
> *dev_ingress_queue_create(struct net_device *dev);
>   extern void rtnetlink_init(void);
>   extern void __rtnl_unlock(void);
> 
> +#ifdef CONFIG_DEBUG_KERNEL
>   #define ASSERT_RTNL() do { \
>   	if (unlikely(!rtnl_is_locked())) { \
>   		printk(KERN_ERR "RTNL: assertion failed at %s (%d)\n", \
> @@ -789,6 +790,9 @@ extern void __rtnl_unlock(void);
>   		dump_stack(); \
>   	} \
>   } while(0)
> +#else
> +#define ASSERT_RTNL()
> +#endif
> 
>   static inline u32 rtm_get_table(struct rtattr **rta, u8 table)
>   {

Probably a worthwhile thing to do, IMO.  If there's some net-specific
CONFIG_DEBUG_ setting then that wold be a better thing to use.

However the patch was a) wordwrapped, b) space-stuffed and c) not cc'ed
to the networking list.  So its prospects are dim.
