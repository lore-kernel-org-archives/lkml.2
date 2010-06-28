Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0F1KRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:17:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56492 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0F1KRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:17:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=eAidlNECtmoSBeUuaAGaN71Wv/rUJURCu4Db5q+UPeoPQqunjuou59Hnf0idOxbMiT
         tqmVvYjb6eaYGLpWEPiLtjc7wvXYiYvh/NUppn0ksnpLJT8kAEO924+s7s5ErsBp5AF4
         4DulzYWA2/LF4WYbrn4Iu9sQrnLkIgLnf5EDI=
MIME-Version: 1.0
Reply-To: dkirjanov@kernel.org
In-Reply-To: <1277644847-16292-1-git-send-email-segooon@gmail.com>
References: <1277644847-16292-1-git-send-email-segooon@gmail.com>
Date: Mon, 28 Jun 2010 14:12:18 +0400
Message-ID: <AANLkTil3gkyn5vY9o0JYluRB4qUp1hdyfOHbX97OZfGJ@mail.gmail.com>
Subject: Re: [PATCH 1/5] staging: slicoss: Change return codes to -EYYY.
From: Denis Kirjanov <kirjanov@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Lior Dotan <liodot@gmail.com>,
       charrer@alacritech.com, "David S. Miller" <davem@davemloft.net>,
       Jiri Pirko <jpirko@redhat.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 5:20 PM, Kulikov Vasiliy <segooon@gmail.com> wrote:
> Change defined STATUS_XXX return codes to standard -EYYY.
>
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/slicoss/slicoss.c |   52 ++++++++++++++++++------------------
>  1 files changed, 26 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> index bebf0fd..102d3ea 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -452,7 +452,7 @@ static int __devinit slic_entry_probe(struct pci_dev *pcidev,
>
>        status = slic_card_init(card, adapter);
>
> -       if (status != STATUS_SUCCESS) {
> +       if (status != 0) {
>                card->state = CARD_FAIL;
>                adapter->state = ADAPT_FAIL;
>                adapter->linkstate = LINK_DOWN;

Can we really continue here?

> @@ -513,7 +513,7 @@ static int slic_entry_open(struct net_device *dev)
>        }
>        status = slic_if_init(adapter);
>
> -       if (status != STATUS_SUCCESS) {
> +       if (status != 0) {
>                if (adapter->activated) {
>                        card->adapters_activated--;
>                        slic_global.num_slic_ports_active--;
> @@ -535,7 +535,7 @@ static int slic_entry_open(struct net_device *dev)
>                locked = 0;
>        }
>
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  static void __devexit slic_entry_remove(struct pci_dev *pcidev)
> @@ -628,7 +628,7 @@ static int slic_entry_halt(struct net_device *dev)
>
>        spin_unlock_irqrestore(&slic_global.driver_lock.lock,
>                                slic_global.driver_lock.flags);
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> @@ -1206,7 +1206,7 @@ static void slic_link_event_handler(struct adapter *adapter)
>  #else
>        Stop compilation;
>  #endif
> -       ASSERT((status == STATUS_SUCCESS) || (status == STATUS_PENDING));
> +       ASSERT(status == 0);
>  }
>

Now that looks useless since slic_upr_request can return STATUS_PENDING
or -ENOMEM. Same for slic_config_get

>  static void slic_init_cleanup(struct adapter *adapter)
> @@ -1265,7 +1265,7 @@ static int slic_mcast_add_list(struct adapter *adapter, char *address)
>        mlist = adapter->mcastaddrs;
>        while (mlist) {
>                if (!compare_ether_addr(mlist->address, address))
> -                       return STATUS_SUCCESS;
> +                       return 0;
>                mlist = mlist->next;
>        }
>
> @@ -1279,7 +1279,7 @@ static int slic_mcast_add_list(struct adapter *adapter, char *address)
>        mcaddr->next = adapter->mcastaddrs;
>        adapter->mcastaddrs = mcaddr;
>
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  /*
> @@ -1365,7 +1365,7 @@ static void slic_mcast_set_bit(struct adapter *adapter, char *address)
>  static void slic_mcast_set_list(struct net_device *dev)
>  {
>        struct adapter *adapter = netdev_priv(dev);
> -       int status = STATUS_SUCCESS;
> +       int status = 0;
>        char *addresses;
>        struct netdev_hw_addr *ha;
>
> @@ -1374,7 +1374,7 @@ static void slic_mcast_set_list(struct net_device *dev)
>        netdev_for_each_mc_addr(ha, dev) {
>                addresses = (char *) &ha->addr;
>                status = slic_mcast_add_list(adapter, addresses);
> -               if (status != STATUS_SUCCESS)
> +               if (status != 0)
>                        break;
>                slic_mcast_set_bit(adapter, addresses);
>        }
> @@ -1394,7 +1394,7 @@ static void slic_mcast_set_list(struct net_device *dev)
>                adapter->devflags_prev = dev->flags;
>                slic_config_set(adapter, true);
>        } else {
> -               if (status == STATUS_SUCCESS)
> +               if (status == 0)
>                        slic_mcast_set_mask(adapter);
>        }
>        return;
> @@ -1476,7 +1476,7 @@ static int slic_if_init(struct adapter *adapter)
>                        adapter->macopts |= MAC_MCAST;
>        }
>        status = slic_adapter_allocresources(adapter);
> -       if (status != STATUS_SUCCESS) {
> +       if (status != 0) {
>                dev_err(&dev->dev,
>                        "%s: slic_adapter_allocresources FAILED %x\n",
>                        __func__, status);
> @@ -1553,7 +1553,7 @@ static int slic_if_init(struct adapter *adapter)
>        slic_link_config(adapter, LINK_AUTOSPEED, LINK_AUTOD);
>        slic_link_event_handler(adapter);
>
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  static void slic_unmap_mmio_space(struct adapter *adapter)
> @@ -1587,7 +1587,7 @@ static int slic_adapter_allocresources(struct adapter *adapter)
>                }
>                adapter->intrregistered = 1;
>        }
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  static void slic_config_pci(struct pci_dev *pcidev)
> @@ -1967,7 +1967,7 @@ static int slic_card_download(struct adapter *adapter)
>           and reach mainloop */
>        mdelay(20);
>
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  MODULE_FIRMWARE("slicoss/oasisdownload.sys");
> @@ -2027,7 +2027,7 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
>        /* Download the microcode */
>        status = slic_card_download(adapter);
>
> -       if (status != STATUS_SUCCESS) {
> +       if (status != 0) {
>                dev_err(&adapter->pcidev->dev,
>                        "download failed bus %d slot %d\n",
>                        adapter->busnumber, adapter->slotnumber);
> @@ -2203,7 +2203,7 @@ static int slic_card_init(struct sliccard *card, struct adapter *adapter)
>        card->state = CARD_UP;
>        card->reset_in_progress = 0;
>
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  static u32 slic_card_locate(struct adapter *adapter)
> @@ -2267,7 +2267,7 @@ static u32 slic_card_locate(struct adapter *adapter)
>
>        ASSERT(card);
>        if (!card)
> -               return STATUS_FAILURE;
> +               return -ENOMEM;

Is -ENOMEM correct for this case?

>        /* Put the adapter in the card's adapter list */
>        ASSERT(card->adapter[adapter->port] == NULL);
>        if (!card->adapter[adapter->port]) {
> @@ -2637,7 +2637,7 @@ static int slic_upr_queue_request(struct adapter *adapter,
>        } else {
>                adapter->upr_list = upr;
>        }
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  static int slic_upr_request(struct adapter *adapter,
> @@ -2653,7 +2653,7 @@ static int slic_upr_request(struct adapter *adapter,
>                                        upr_request,
>                                        upr_data,
>                                        upr_data_h, upr_buffer, upr_buffer_h);
> -       if (status != STATUS_SUCCESS) {
> +       if (status != 0) {
>                spin_unlock_irqrestore(&adapter->upr_lock.lock,
>                                        adapter->upr_lock.flags);
>                return status;
> @@ -2661,7 +2661,7 @@ static int slic_upr_request(struct adapter *adapter,
>        slic_upr_start(adapter);
>        spin_unlock_irqrestore(&adapter->upr_lock.lock,
>                                adapter->upr_lock.flags);
> -       return STATUS_PENDING;
> +       return 0;
>  }
>
>  static void slic_upr_request_complete(struct adapter *adapter, u32 isr)
> @@ -3032,7 +3032,7 @@ static int slic_rspqueue_init(struct adapter *adapter)
>                        dev_err(&adapter->pcidev->dev,
>                                "pci_alloc_consistent failed\n");
>                        slic_rspqueue_free(adapter);
> -                       return STATUS_FAILURE;
> +                       return -ENOMEM;
>                }
>  #ifndef CONFIG_X86_64
>                ASSERT(((u32) rspq->vaddr[i] & 0xFFFFF000) ==
> @@ -3056,7 +3056,7 @@ static int slic_rspqueue_init(struct adapter *adapter)
>        rspq->offset = 0;
>        rspq->pageindex = 0;
>        rspq->rspbuf = (struct slic_rspbuf *)rspq->vaddr[0];
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  static void slic_rspqueue_free(struct adapter *adapter)
> @@ -3180,13 +3180,13 @@ static int slic_cmdq_init(struct adapter *adapter)
>  #endif
>                if (!pageaddr) {
>                        slic_cmdq_free(adapter);
> -                       return STATUS_FAILURE;
> +                       return -ENOMEM;
>                }
>                slic_cmdq_addcmdpage(adapter, pageaddr);
>        }
>        adapter->slic_handle_ix = 1;
>
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  static void slic_cmdq_free(struct adapter *adapter)
> @@ -3407,9 +3407,9 @@ static int slic_rcvqueue_init(struct adapter *adapter)
>        }
>        if (rcvq->count < SLIC_RCVQ_MINENTRIES) {
>                slic_rcvqueue_free(adapter);
> -               return STATUS_FAILURE;
> +               return -ENOMEM;
>        }
> -       return STATUS_SUCCESS;
> +       return 0;
>  }
>
>  static void slic_rcvqueue_free(struct adapter *adapter)
> --
> 1.7.0.4
>
>



-- 
Regards,
Denis
