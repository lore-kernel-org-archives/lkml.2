Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2GYKCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 06:02:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26272 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2GYKCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 06:02:33 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-84-500fc437b59d
Message-id: <500FC428.8030305@samsung.com>
Date: Wed, 25 Jul 2012 19:02:16 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615
 Thunderbird/13.0.1
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>,
        Olof Johansson <olofj@chromium.org>, shashidharh@vayavyalabs.com,
        ki0351.kim@samsung.com
Subject: Re: [PATCH v3] mmc: dw_mmc: Disable low power mode if SDIO interrupts
 are used
References: <CAD=FV=Wa1bCRvLNnFjhht6nvNorm3CRzX5zrn-YDA2Jec1K3Eg@mail.gmail.com>
 <1343149145-22927-1-git-send-email-dianders@chromium.org>
In-reply-to: <1343149145-22927-1-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQV3zI/wBBo39mhaXd81hszjyv5/R
	gcnj8ya5AMYoLpuU1JzMstQifbsEroxnDfdYC/6wVpy96d3AeIWli5GTQ0LARGL6gxlMELaY
	xIV769m6GLk4hASmM0psfHKcFcJ5ySjxZscvVpAqXgEtiRmzjoB1sAioSkyZMg8sziagI7H9
	23GwuKhAmMSruz/ZIOoFJX5Mvge2TURAU+JZw0tmkKHMAv+YJNY8bwNLCAtEShz4toMdYlsf
	o8Sc2RPAujkF3CReN3WCTWUG2rC/dRobhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCw/GZ1A7GlQ0WhxgFOBiVeHh/PuELEGJNLCuuzD3EKMHB
	rCTC27qbP0CINyWxsiq1KD++qDQntfgQozQHi5I4r7H3V38hgfTEktTs1NSC1CKYLBMHp1QD
	Y09U6xH93zm7/DpOri0907D0eonzCqerXTqyYd0vp0w41XzRu/7GzB2hwgeOCjr+VUxkn5d3
	dhqPuZOp9Dy3xX/bbooJSPPsDlHj1/Z0VAjNiF1nVM5YlGkWd+rO9WNqRj/V4s8G6bJYJl69
	FvV5tfG94ud3wu6cnrJWfFai2UmlXqFEHvc2JZbijERDLeai4kQAjC3kQkMCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
>  static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>  {
>  	struct dw_mci_slot *slot = mmc_priv(mmc);
> @@ -871,6 +898,14 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>  	/* Enable/disable Slot Specific SDIO interrupt */
>  	int_mask = mci_readl(host, INTMASK);
>  	if (enb) {
> +		/*
> +		 * Turn off low power mode if it was enabled.  This is a bit of
> +		 * a heavy operation and we disable / enable IRQs a lot, so
> +		 * we'll leave low power mode disabled and it will get
> +		 * re-enabled again in dw_mci_setup_bus().
> +		 */
> +		dw_mci_disable_low_power(mmc_priv(mmc));
Just use the slot. slot is already assigned to mmc_priv(mmc)

Reviewed-by: Jaehoon Chung <jh80.chung@samsung.com>


