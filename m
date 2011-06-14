Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1FNIXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 04:23:52 -0400
Received: from smtp2.infomaniak.ch ([84.16.68.90]:38492 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1FNIXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 04:23:49 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 04:23:48 EDT
MIME-Version: 1.0
In-Reply-To: <486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
References: <cover.1308024069.git.joe@perches.com>
	<486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
Date: Tue, 14 Jun 2011 10:18:12 +0200
Message-ID: <BANLkTimdj-p9a+615JPe6oUJQqQo4_+-rA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] drivers/net: Remove casts of void *
From: Daniele Venzano <venza@brownhat.org>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        Jie Yang <jie.yang@atheros.com>,
        Sathya Perla <sathya.perla@emulex.com>,
        Subbu Seetharaman <subbu.seetharaman@emulex.com>,
        Ajit Khaparde <ajit.khaparde@emulex.com>,
        Rasesh Mody <rmody@brocade.com>, Debashis Dutt <ddutt@brocade.com>,
        Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Divy Le Ray <divy@chelsio.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        Amit Kumar Salecha <amit.salecha@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>, linux-driver@qlogic.com,
        Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
        Jon Mason <jdmason@kudzu.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Steve Hodgson <shodgson@solarflare.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Dillow <dave@thedillows.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/14 Joe Perches <joe@perches.com>:
> Unnecessary casts of void * clutter the code.

> diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
> index 484f795..658a192 100644
> --- a/drivers/net/sis900.c
> +++ b/drivers/net/sis900.c
> @@ -482,7 +482,7 @@ static int __devinit sis900_probe(struct pci_dev *pci_dev,
>                ret = -ENOMEM;
>                goto err_out_cleardev;
>        }
> -       sis_priv->tx_ring = (BufferDesc *)ring_space;
> +       sis_priv->tx_ring = ring_space;
>        sis_priv->tx_ring_dma = ring_dma;
>
>        ring_space = pci_alloc_consistent(pci_dev, RX_TOTAL_SIZE, &ring_dma);
> @@ -490,7 +490,7 @@ static int __devinit sis900_probe(struct pci_dev *pci_dev,
>                ret = -ENOMEM;
>                goto err_unmap_tx;
>        }
> -       sis_priv->rx_ring = (BufferDesc *)ring_space;
> +       sis_priv->rx_ring = ring_space;
>        sis_priv->rx_ring_dma = ring_dma;
>
>        /* The SiS900-specific entries in the device structure. */

sis900 looks good, too.

-- 
Daniele Venzano
venza@brownhat.org
http://www.brownhat.org
