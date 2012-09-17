Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2IQMKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 08:10:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50891 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755969Ab2IQMKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:10:52 -0400
Message-ID: <505712FE.3040500@mvista.com>
Date: Mon, 17 Sep 2012 16:09:34 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vipul Kumar Samar <vipulkumar.samar@st.com>
CC: grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net,
        linus.walleij@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi: pl022:  Add clk_{un}prepare() support in runtime
 PM
References: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
In-Reply-To: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-09-2012 14:37, Vipul Kumar Samar wrote:

> clk_{un}prepare is mandatory for platforms using common clock framework. Add
> clk_{un}prepare() support for spi-pl022 runtime PM.

> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
[...]

> @@ -2342,10 +2342,13 @@ static int pl022_runtime_suspend(struct device *dev)
>   static int pl022_runtime_resume(struct device *dev)
>   {
>   	struct pl022 *pl022 = dev_get_drvdata(dev);
> +	int ret = 0;

    Don't need to init it at all.

> -	clk_enable(pl022->clk);
> +	ret = clk_prepare_enable(pl022->clk);
> +	if (ret)
> +		dev_err(dev, "could not enable SSP/SPI bus clock\n");
>
> -	return 0;
> +	return ret;
>   }
>   #endif

WBR, Sergei

