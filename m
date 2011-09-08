Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1IHOwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:52:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1IHOwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:52:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH] dmaengine: add CSR SiRFprimaII DMAC driver
Date: Thu, 8 Sep 2011 16:52:20 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, workgroup.linux@csr.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rongjun Ying <rongjun.ying@csr.com>
References: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
In-Reply-To: <1315374075-15479-1-git-send-email-Baohua.Song@csr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081652.20552.arnd@arndb.de>
X-Provags-ID: V02:K0:NcU1CSj4DEQpIAcDy88ql6NIJA6ZLcyrwNM0nIBIkT1
 kerCY/Sn4HP1RC5D/IuBuaN5Tgb+HllRoGcNn2oEfCKQirQi0B
 xQ4N3NbuKdDQQwxVcsXSufmtJxNImj8MLtdTQqId1sguRwJAiq
 p3EqhWkQq3DNZlT7vdZIKIRS3k0mtZkHEE3xIAAobhqtUlgB5l
 WuuNvC5fQUubUgk0sTSGadzPXMNO18Uk10q07vqJuHJTC9Tihj
 sIwqO+snA/oumSxUv+p38CaH0e3HagGvY5pBp+xM5pVt5m/H6B
 xIbPx1FN2/R9CWifM1A0syeo//ZbyDYUlVpisDIq07j0Q8P2jn
 sy/k36IUFLzry1rJn6VM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 September 2011, Barry Song wrote:
> +/*
> + * The DMA controller consists of 16 independent DMA channels.
> + * Each channel is allocated to a different function
> + */
> +bool sirfsoc_dma_filter_id(struct dma_chan *chan, void *chan_id)
> +{
> +       unsigned int ch_nr = (unsigned int) chan_id;
> +
> +       if (ch_nr == chan->chan_id)
> +               return true;
> +
> +       return false;
> +}
> +EXPORT_SYMBOL(sirfsoc_dma_filter_id);
> +

Hi Barry,

It seems wrong that you have to export this function. The dmaengine API
should be able to work without this, and when you have drivers using the
interface, those should not rely on a specific implementation as the
purpose of the API is specifically to hide that.

Am I missing something?

	Arnd
