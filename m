Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2CZHR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 03:17:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40519 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2CZHR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 03:17:56 -0400
MIME-Version: 1.0
In-Reply-To: <1332426216-25273-1-git-send-email-kumarrav@codeaurora.org>
References: <1332426216-25273-1-git-send-email-kumarrav@codeaurora.org>
Date: Mon, 26 Mar 2012 09:17:55 +0200
Message-ID: <CACRpkdbk=Hu6CzXSkkTgNsXGN0tPjfzLYfUpL8D5sxz2=efFxQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 ADM DMA APIs
From: Linus Walleij <linus.walleij@linaro.org>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.or,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tsoni@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 3:23 PM, Ravi Kumar V <kumarrav@codeaurora.org> wrote:

This stuff:

> +enum adm_flush_type {
> +       ADM_FORCED_FLUSH,
> +       ADM_GRACEFUL_FLUSH,
> +};

> +/*
> + *  Controlling the hardware channel like stopping, flushing.
> + */
> +static int msm_dma_chan_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +                                                       unsigned long arg)
> +{
> +       enum adm_flush_type cmd_type = arg;
> +
> +       if (cmd == DMA_TERMINATE_ALL) {
> +               switch (cmd_type) {
> +               case ADM_GRACEFUL_FLUSH:
> +                               msm_dmov_stop_cmd(chan->chan_id, NULL, 1);
> +                       break;
> +               case ADM_FORCED_FLUSH:
> +                       /*
> +                        * We treate default as forced flush
> +                        * so we fall through
> +                        */
> +               default:
> +                               msm_dmov_stop_cmd(chan->chan_id, NULL, 0);
> +                       break;
> +               }
> +       }
> +       return 0;
> +}

This is an interesting way of using the opaque arg. Can you describe
the different semantics of graceful vs forced flush so we understand
the usecases for them?

DMA_TERMINATE_ALL is usually not very graceful.

DMA_PAUSE might be the semantic you're looking for as the
graceful path, and then you can do away with this strange
enum altogether.

Yours,
Linus Walleij
