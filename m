Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2IQKuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:50:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47859 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2IQKuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:50:51 -0400
MIME-Version: 1.0
In-Reply-To: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
References: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
Date: Mon, 17 Sep 2012 16:20:50 +0530
X-Google-Sender-Auth: lxkOSlCjLElq2cpp5z4Wh4p5lVM
Message-ID: <CAOh2x==hxYpfQtW6vzgvqp8YFhtxyESnS5_ebjwO9c0K5FHqhw@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: Add clk_{un}prepare() support in runtime PM
From: viresh kumar <viresh.kumar@linaro.org>
To: Vipul Kumar Samar <vipulkumar.samar@st.com>
Cc: grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net,
        linus.walleij@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 4:07 PM, Vipul Kumar Samar
<vipulkumar.samar@st.com> wrote:
> clk_{un}prepare is mandatory for platforms using common clock framework. Add
> clk_{un}prepare() support for spi-pl022 runtime PM.

You are not calling these routines in actualy patch.. Fix commit log and add my
Reviewed-by.

> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> ---
>  drivers/spi/spi-pl022.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> index f2a80ff..500e75e 100644
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@ -2334,7 +2334,7 @@ static int pl022_runtime_suspend(struct device *dev)
>  {
>         struct pl022 *pl022 = dev_get_drvdata(dev);
>
> -       clk_disable(pl022->clk);
> +       clk_disable_unprepare(pl022->clk);
>
>         return 0;
>  }
> @@ -2342,10 +2342,13 @@ static int pl022_runtime_suspend(struct device *dev)
>  static int pl022_runtime_resume(struct device *dev)
>  {
>         struct pl022 *pl022 = dev_get_drvdata(dev);
> +       int ret = 0;
>
> -       clk_enable(pl022->clk);
> +       ret = clk_prepare_enable(pl022->clk);
> +       if (ret)
> +               dev_err(dev, "could not enable SSP/SPI bus clock\n");
>
> -       return 0;
> +       return ret;
>  }
>  #endif
>
> --
> 1.7.2.2
>
>
> ------------------------------------------------------------------------------
> Live Security Virtual Conference
> Exclusive live event will cover all the ways today's security and
> threat landscape has changed and how IT managers can respond. Discussions
> will include endpoint security, mobile security and the latest in malware
> threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
