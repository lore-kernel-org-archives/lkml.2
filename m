Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0ELOzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:55:39 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:50295 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0ELOzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:55:37 -0400
Subject: Re: [PATCH 2/5] drivers/s390/net: Drop memory allocation cast
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: ursula.braun@de.ibm.com, blaschka@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com, heicars2@linux.vnet.ibm.com,
       linux-s390@vger.kernel.org, linux390@de.ibm.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <OFA176CF49.39A9A029-ONC1257721.00506DA9-C1257721.0050820A@de.ibm.com>
References: <OFA176CF49.39A9A029-ONC1257721.00506DA9-C1257721.0050820A@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 16:55:34 +0200
Message-ID: <1273676134.18115.9.camel@braunu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Julia, we have added your patch to our local repository and will
submit it for upstream integration.


> From: Julia Lawall <julia@diku.dk>
> 
> Drop cast on the result of kmalloc and similar functions.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> type T;
> @@
> 
> - (T *)
>  (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
>   kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> drivers/s390/net/ctcm_main.c      |    6 ++----
> drivers/s390/net/ctcm_mpc.c       |    6 ++----
> drivers/s390/net/lcs.c            |    3 +--
> drivers/s390/net/qeth_core_main.c |    2 +-
> 4 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/s390/net/ctcm_main.c
> b/drivers/s390/net/ctcm_main.c
> index e35713d..4ecafbf 100644
> --- a/drivers/s390/net/ctcm_main.c
> +++ b/drivers/s390/net/ctcm_main.c
> @@ -1364,8 +1364,7 @@ static int add_channel(struct ccw_device *cdev,
> enum ctcm_channel_types type,
> 
>                  ch->protocol = priv->protocol;
>                  if (IS_MPC(priv)) {
> -                                  ch->discontact_th = (struct
> th_header *)
> -
>  kzalloc(TH_HEADER_LENGTH, gfp_type());
> +                                  ch->discontact_th =
> kzalloc(TH_HEADER_LENGTH, gfp_type());
>                                   if (ch->discontact_th == NULL)
> 
>                goto nomem_return;
> 
> @@ -1379,8 +1378,7 @@ static int add_channel(struct ccw_device *cdev,
> enum ctcm_channel_types type,
>                  } else
>                                   ccw_num = 8;
> 
> -                 ch->ccw = (struct ccw1 *)
> -                                  kzalloc(ccw_num * sizeof(struct
> ccw1), GFP_KERNEL | GFP_DMA);
> +                 ch->ccw = kzalloc(ccw_num * sizeof(struct ccw1),
> GFP_KERNEL | GFP_DMA);
>                  if (ch->ccw == NULL)
> 
>                goto nomem_return;
> 
> diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
> index 5978b39..87c24d2 100644
> --- a/drivers/s390/net/ctcm_mpc.c
> +++ b/drivers/s390/net/ctcm_mpc.c
> @@ -669,8 +669,7 @@ static void ctcmpc_send_sweep_resp(struct channel
> *rch)
> 
> goto done;
>                  }
> 
> -                 header = (struct th_sweep *)
> -
> kmalloc(sizeof(struct th_sweep), gfp_type());
> +                 header = kmalloc(sizeof(struct th_sweep),
> gfp_type());
> 
>                  if (!header) {
>                                   dev_kfree_skb_any(sweep_skb);
> @@ -1191,8 +1190,7 @@ static void ctcmpc_unpack_skb(struct channel
> *ch, struct sk_buff *pskb)
>                                                    skb_pull(pskb,
> new_len); /* point to next PDU */
>                                   }
>                  } else {
> -                                  mpcginfo = (struct mpcg_info *)
> -
>  kmalloc(sizeof(struct mpcg_info), gfp_type());
> +                                  mpcginfo = kmalloc(sizeof(struct
> mpcg_info), gfp_type());
>                                   if (mpcginfo == NULL)
> 
>                goto done;
> 
> diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
> index 9b19ea1..0f19d54 100644
> --- a/drivers/s390/net/lcs.c
> +++ b/drivers/s390/net/lcs.c
> @@ -1238,8 +1238,7 @@ lcs_set_mc_addresses(struct lcs_card *card,
> struct in_device *in4_dev)
>                                   ipm = lcs_check_addr_entry(card,
> im4, buf);
>                                   if (ipm != NULL)
>                                                    continue;
>         /* Address already in list. */
> -                                  ipm = (struct lcs_ipm_list *)
> -
> kzalloc(sizeof(struct lcs_ipm_list), GFP_ATOMIC);
> +                                  ipm = kzalloc(sizeof(struct
> lcs_ipm_list), GFP_ATOMIC);
>                                   if (ipm == NULL) {
>                                                    pr_info("Not enough
> memory to add"
>                                                                     "
> new multicast entry!\n");
> diff --git a/drivers/s390/net/qeth_core_main.c
> b/drivers/s390/net/qeth_core_main.c
> index 3ba738b..065a3fa 100644
> --- a/drivers/s390/net/qeth_core_main.c
> +++ b/drivers/s390/net/qeth_core_main.c
> @@ -606,7 +606,7 @@ static int qeth_setup_channel(struct qeth_channel
> *channel)
> 
>                  QETH_DBF_TEXT(SETUP, 2, "setupch");
>                  for (cnt = 0; cnt < QETH_CMD_BUFFER_NO; cnt++) {
> -                                  channel->iob[cnt].data = (char *)
> +                                  channel->iob[cnt].data =
> 
>  kmalloc(QETH_BUFSIZE, GFP_DMA|GFP_KERNEL);
>                                   if (channel->iob[cnt].data == NULL)
>                                                    break;
> 


