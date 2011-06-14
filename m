Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1FNKee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:34:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59481 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab1FNKeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WzSxQqMJ+2FKihvGriDeADamnc8LLNc7mpO7+gWUcBrDTOWoWzo4VrcvjrKa+U1cI9
         NjjMfPLEp7f5tFvKS4EUmnqwwuTsXIw1sppPJZpkUvhYXBUao3OzrZkOIThX/qnYzUUH
         vd8xalW7qU2P+b2h/F/x35uSh+R1zISlQpYP4=
MIME-Version: 1.0
In-Reply-To: <486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
References: <cover.1308024069.git.joe@perches.com> <486a21b708a9dce0c1c0059a21a2f9b66dac9e3c.1308024069.git.joe@perches.com>
From: Chris Snook <chris.snook@gmail.com>
Date: Tue, 14 Jun 2011 06:34:10 -0400
Message-ID: <BANLkTik8+OK3QNreHLn7rqx-s4UXNypOEg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] drivers/net: Remove casts of void *
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jay Cliburn <jcliburn@gmail.com>, Jie Yang <jie.yang@atheros.com>,
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
        Daniele Venzano <venza@brownhat.org>,
        David Dillow <dave@thedillows.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 12:02 AM, Joe Perches <joe@perches.com> wrote:

> diff --git a/drivers/net/atl1e/atl1e_main.c b/drivers/net/atl1e/atl1e_main.c
> index 86a9122..c3c5db1 100644
> --- a/drivers/net/atl1e/atl1e_main.c
> +++ b/drivers/net/atl1e/atl1e_main.c
> @@ -800,8 +800,7 @@ static int atl1e_setup_ring_resources(struct atl1e_adapter *adapter)
>        /* Init TPD Ring */
>        tx_ring->dma = roundup(adapter->ring_dma, 8);
>        offset = tx_ring->dma - adapter->ring_dma;
> -       tx_ring->desc = (struct atl1e_tpd_desc *)
> -                       (adapter->ring_vir_addr + offset);
> +       tx_ring->desc = adapter->ring_vir_addr + offset;
>        size = sizeof(struct atl1e_tx_buffer) * (tx_ring->count);
>        tx_ring->tx_buffer = kzalloc(size, GFP_KERNEL);
>        if (tx_ring->tx_buffer == NULL) {
> @@ -827,7 +826,7 @@ static int atl1e_setup_ring_resources(struct atl1e_adapter *adapter)
>
>        /* Init CMB dma address */
>        tx_ring->cmb_dma = adapter->ring_dma + offset;
> -       tx_ring->cmb     = (u32 *)(adapter->ring_vir_addr + offset);
> +       tx_ring->cmb = adapter->ring_vir_addr + offset;
>        offset += sizeof(u32);
>
>        for (i = 0; i < adapter->num_rx_queues; i++) {
> diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
> index 16249e9..24e1592 100644
> --- a/drivers/net/atlx/atl2.c
> +++ b/drivers/net/atlx/atl2.c
> @@ -311,8 +311,7 @@ static s32 atl2_setup_ring_resources(struct atl2_adapter *adapter)
>        adapter->txd_dma = adapter->ring_dma ;
>        offset = (adapter->txd_dma & 0x7) ? (8 - (adapter->txd_dma & 0x7)) : 0;
>        adapter->txd_dma += offset;
> -       adapter->txd_ring = (struct tx_pkt_header *) (adapter->ring_vir_addr +
> -               offset);
> +       adapter->txd_ring = adapter->ring_vir_addr + offset;
>
>        /* Init TXS Ring */
>        adapter->txs_dma = adapter->txd_dma + adapter->txd_ring_size;

atlx looks fine.

Acked-By: Chris Snook <chris.snook@gmail.com>
