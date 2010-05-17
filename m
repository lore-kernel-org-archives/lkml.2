Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0EQVGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:06:45 -0400
Received: from mail.perches.com ([173.55.12.10]:2307 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab0EQVGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:06:43 -0400
Subject: Re: [PATCH 229/229] Staging: Rt2860: Fixed all but one error in
 mlme.h.
From: Joe Perches <joe@perches.com>
To: Neil Munro <neilmunro@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1274096666-3282-1-git-send-email-neilmunro@gmail.com>
References: <1274096666-3282-1-git-send-email-neilmunro@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 14:06:41 -0700
Message-ID: <1274130401.17703.20.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 12:44 +0100, Neil Munro wrote: 
> Fixed all but error in mlme.h, I don't know how to fix the remaining
> error. It complains about parenthesis and do-while loops, maybe
> someone else can fix that?

Hello Neil.

>  drivers/staging/rt2860/mlme.h |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/rt2860/mlme.h b/drivers/staging/rt2860/mlme.h
> index 1143413..63cada3 100644
> --- a/drivers/staging/rt2860/mlme.h
> +++ b/drivers/staging/rt2860/mlme.h
> @@ -60,7 +60,7 @@
>  #define JAP_W56	4
>  #define MAX_RD_REGION 5
>  
> -#define BEACON_LOST_TIME            4 * OS_HZ	/* 2048 msec = 2 sec */
> +#define BEACON_LOST_TIME            { 4 * OS_HZ }	/* 2048 msec = 2 sec */

You want parentheses not braces here.

> #define DLS_TIMEOUT                 1200	/* unit: msec */
>  #define AUTH_TIMEOUT                300	/* unit: msec */
> @@ -119,8 +119,8 @@
>  #define MAC_ADDR_IS_GROUP(Addr)       (((Addr[0]) & 0x01))

This should be is_multicast_ether_addr(Addr) I presume.
It'd probably be better to remove the macro and just
use is_multicast_ether_addr in the code directly.

> #define MAC_ADDR_HASH(Addr)            (Addr[0] ^ Addr[1] ^ Addr[2] ^ Addr[3] ^ Addr[4] ^ Addr[5])
>  #define MAC_ADDR_HASH_INDEX(Addr)      (MAC_ADDR_HASH(Addr) % HASH_TABLE_SIZE)
> -#define TID_MAC_HASH(Addr,TID)            (TID^Addr[0] ^ Addr[1] ^ Addr[2] ^ Addr[3] ^ Addr[4] ^ Addr[5])
> -#define TID_MAC_HASH_INDEX(Addr,TID)      (TID_MAC_HASH(Addr,TID) % HASH_TABLE_SIZE)
> +#define TID_MAC_HASH(Addr, TID)            (TID^Addr[0] ^ Addr[1] ^ Addr[2] ^ Addr[3] ^ Addr[4] ^ Addr[5])

It'd be better to use consistent spacing for xors.

#define TID_MAC_HASH(Addr, TID)		(TID ^ Addr[0] ^ Addr[1] ^ Addr[2] ^ Addr[3] ^ Addr[4] ^ Addr[5])
or
#define TID_MAC_HASH(Addr, TID)		(TID ^ MAC_ADDR_HASH(Addr))

> +#define TID_MAC_HASH_INDEX(Addr, TID)      (TID_MAC_HASH(Addr, TID) % HASH_TABLE_SIZE)
>  
>  /* LED Control */
>  /* assoiation ON. one LED ON. another blinking when TX, OFF when idle */
> @@ -145,7 +145,7 @@
>  #define CAP_IS_DSSS_OFDM(x)              (((x) & 0x2000) != 0)
>  #define CAP_IS_DELAY_BA(x)               (((x) & 0x4000) != 0)	/* 802.11e d9 */
>  
> -#define CAP_GENERATE(ess,ibss,priv,s_pre,s_slot,spectrum)  (((ess) ? 0x0001 : 0x0000) | ((ibss) ? 0x0002 : 0x0000) | ((priv) ? 0x0010 : 0x0000) | ((s_pre) ? 0x0020 : 0x0000) | ((s_slot) ? 0x0400 : 0x0000) | ((spectrum) ? 0x0100 : 0x0000))
> +#define CAP_GENERATE(ess, ibss, priv, s_pre, s_slot, spectrum)  (((ess) ? 0x0001 : 0x0000) | ((ibss) ? 0x0002 : 0x0000) | ((priv) ? 0x0010 : 0x0000) | ((s_pre) ? 0x0020 : 0x0000) | ((s_slot) ? 0x0400 : 0x0000) | ((spectrum) ? 0x0100 : 0x0000))

Rather a long line.  Maybe better as something like: 
#define CAP_GENERATE(ess, ibss, priv, s_pre, s_slot, spectrum)	\
	(((ess)		? 0x0001 : 0x0000) |			\
	 ((ibss)	? 0x0002 : 0x0000) |			\
	 ((priv)	? 0x0010 : 0x0000) |			\
	 ((s_pre)	? 0x0020 : 0x0000) |			\
	 ((s_slot)	? 0x0400 : 0x0000) |			\
	 ((spectrum)	? 0x0100 : 0x0000))

> #define ERP_IS_NON_ERP_PRESENT(x)        (((x) & 0x01) != 0)	/* 802.11g */
> #define ERP_IS_USE_PROTECTION(x)         (((x) & 0x02) != 0)	/* 802.11g */
> @@ -176,8 +176,7 @@
>  
>  /* reset all OneSecTx counters */
>  #define RESET_ONE_SEC_TX_CNT(__pEntry) \
> -if (((__pEntry)) != NULL) \
> -{ \
> +if (((__pEntry)) != NULL) { \
>  	(__pEntry)->OneSecTxRetryOkCount = 0; \
>  	(__pEntry)->OneSecTxFailCount = 0; \
>  	(__pEntry)->OneSecTxNoRetryOkCount = 0; \

Ideally surrounded by a do { foo } while (0)

> @@ -846,7 +845,7 @@ struct rt_mlme_queue {
>  	struct rt_mlme_queue_elem Entry[MAX_LEN_OF_MLME_QUEUE];
>  };
>  
> -typedef void(*STATE_MACHINE_FUNC) (void * Adaptor, struct rt_mlme_queue_elem *Elem);
> +typedef void(*STATE_MACHINE_FUNC) (void *Adaptor, struct rt_mlme_queue_elem * Elem);

Might be better without the typedef


