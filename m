Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1AJRWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:22:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:57973 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1AJRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:22:13 -0500
Date: Mon, 10 Jan 2011 09:19:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rob Landley <rlandley@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <trivial@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-embedded@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Move an assert under DEBUG_KERNEL. (attempt 2)
Message-Id: <20110110091959.ff4a2bfe.randy.dunlap@oracle.com>
In-Reply-To: <4D2AC4D5.5070503@parallels.com>
References: <4D2579B2.7060704@parallels.com>
	<20110106154120.b69118c9.akpm@linux-foundation.org>
	<4D2AC4D5.5070503@parallels.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 02:35:33 -0600 Rob Landley wrote:

> On 01/06/2011 05:41 PM, Andrew Morton wrote:
> > Probably a worthwhile thing to do, IMO.  If there's some net-specific
> > CONFIG_DEBUG_ setting then that wold be a better thing to use.
> > 
> > However the patch was a) wordwrapped, b) space-stuffed and c) not cc'ed
> > to the networking list.  So its prospects are dim.
> 
> Ok, either I've beaten thunderbird into submission, or I'll be submitting a patch to Documentation/email-clients.txt.  (Whether or not I need to find a different smtp server to send this through remains an open question.)
> 
> (Confirming: I looked for a more specific DEBUG symbol, but couldn't find one.  I can add one, but this seems a bit small to have its own symbol, and DEBUG_KERNEL is already used in a few *.c files.)
> 
> From: Rob Landley <rlandley@parallels.com>
> 
> Move an assert under DEBUG_KERNEL.  (Minor cleanup to save a few bytes.)
> 
> Signed-off-by: Rob Landley <rlandley@parallels.com>
> ---
> 
>  include/linux/rtnetlink.h |    4 ++++
>  1 file changed, 4 insertions(+)


Hm, cc to linux-net should be to netdev instead (so I changed it).


> diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
> index bbad657..28c4025 100644
> --- a/include/linux/rtnetlink.h
> +++ b/include/linux/rtnetlink.h
> @@ -782,6 +782,7 @@ extern struct netdev_queue *dev_ingress_queue_create(struct net_device *dev);
>  extern void rtnetlink_init(void);
>  extern void __rtnl_unlock(void);
>  
> +#ifdef CONFIG_DEBUG_KERNEL
>  #define ASSERT_RTNL() do { \
>  	if (unlikely(!rtnl_is_locked())) { \
>  		printk(KERN_ERR "RTNL: assertion failed at %s (%d)\n", \
> @@ -789,6 +790,9 @@ extern void __rtnl_unlock(void);
>  		dump_stack(); \
>  	} \
>  } while(0)
> +#else
> +#define ASSERT_RTNL()
> +#endif

Empty macros in Linux usually take the (preferred) form of this one from kernel.h:

#define might_resched() do { } while (0)

although it's up to DaveM in this case.


>  
>  static inline u32 rtm_get_table(struct rtattr **rta, u8 table)
>  {
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
