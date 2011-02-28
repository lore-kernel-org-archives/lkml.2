Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1B1MGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 07:06:46 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55127 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1B1MGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 07:06:45 -0500
Message-ID: <4D6B8F84.40905@ru.mvista.com>
Date: Mon, 28 Feb 2011 15:05:24 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@st.com>
CC: dan.j.williams@intel.com, linus.walleij@stericsson.com, amit.goel@st.com,
        linux-kernel@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 6/8 resend] dw_dmac: Mark all tx_descriptors with DMA_CRTL_ACK
 after xfer finish
References: <cover.1298889267.git.viresh.kumar@st.com> <82027aa0c6446df3f7fb8e3c5fbdc28f60ea33b7.1298889267.git.viresh.kumar@st.com>
In-Reply-To: <82027aa0c6446df3f7fb8e3c5fbdc28f60ea33b7.1298889267.git.viresh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-02-2011 13:41, Viresh Kumar wrote:

> dwc_desc_get checks all descriptors for DMA_CTRL_ACK before allocating them for
> transfers. And descriptors are not marked with DMA_CRTL_ACK after transfer
> finishes. Thus descriptor once used is not usable again. This patch marks
> descriptors with DMA_CRTL_ACK after dma xfer finishes

> Signed-off-by: Viresh Kumar<viresh.kumar@st.com>
> ---
>   drivers/dma/dw_dmac.c |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)

> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index c40b89f..01f783d 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -196,6 +196,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
>   	dma_async_tx_callback		callback;
>   	void				*param;
>   	struct dma_async_tx_descriptor	*txd =&desc->txd;
> +	struct dw_desc	*child;

    Shouldn't this varaible name be aligned with the above variable names?

WBR, Sergei
