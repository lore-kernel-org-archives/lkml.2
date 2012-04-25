Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab2DYFk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 01:40:29 -0400
Received: from londo.lunn.ch ([80.238.139.98]:51211 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758174Ab2DYFk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 01:40:27 -0400
Date: Wed, 25 Apr 2012 07:42:38 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: viresh kumar <viresh.linux@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Viresh Kumar <viresh.kumar@st.com>,
        akpm@linux-foundation.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        linux@arm.linux.org.uk, linux-ide@vger.kernel.org
Subject: Re: [PATCH V3 07/12] ata/sata_mv: Remove conditional compilation of
 clk code
Message-ID: <20120425054238.GG13489@lunn.ch>
Mail-Followup-To: viresh kumar <viresh.linux@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Viresh Kumar <viresh.kumar@st.com>,
	akpm@linux-foundation.org, spear-devel@list.st.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
	linux@arm.linux.org.uk, linux-ide@vger.kernel.org
References: <cover.1335266056.git.viresh.kumar@st.com>
 <abbcf661dc58948794839eb0fba1d5a0950ec848.1335266056.git.viresh.kumar@st.com>
 <20120424120019.GE24089@lunn.ch>
 <CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
 <20120424142939.GG24089@lunn.ch>
 <CAOh2x=kOww+K-VrNJU_v6XXANQUGyBtZ-ekoCAEQV5kEdah7jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x=kOww+K-VrNJU_v6XXANQUGyBtZ-ekoCAEQV5kEdah7jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please see if following is fine:

Hi Viresh

This looks good. Thanks

     Andrew

> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: linux-ide@vger.kernel.org
> ---
>  drivers/ata/sata_mv.c |   10 ----------
>  1 files changed, 0 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
> index 7336d4a..37503b8 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -551,9 +551,7 @@ struct mv_host_priv {
>  	u32			irq_mask_offset;
>  	u32			unmask_all_irqs;
> 
> -#if defined(CONFIG_HAVE_CLK)
>  	struct clk		*clk;
> -#endif
>  	/*
>  	 * These consistent DMA memory pools give us guaranteed
>  	 * alignment for hardware-accessed data structures,
> @@ -4063,13 +4061,11 @@ static int mv_platform_probe(struct
> platform_device *pdev)
>  				   resource_size(res));
>  	hpriv->base -= SATAHC0_REG_BASE;
> 
> -#if defined(CONFIG_HAVE_CLK)
>  	hpriv->clk = clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(hpriv->clk))
>  		dev_notice(&pdev->dev, "cannot get clkdev\n");
>  	else
>  		clk_enable(hpriv->clk);
> -#endif
> 
>  	/*
>  	 * (Re-)program MBUS remapping windows if we are asked to.
> @@ -4096,12 +4092,10 @@ static int mv_platform_probe(struct
> platform_device *pdev)
>  		return 0;
> 
>  err:
> -#if defined(CONFIG_HAVE_CLK)
>  	if (!IS_ERR(hpriv->clk)) {
>  		clk_disable(hpriv->clk);
>  		clk_put(hpriv->clk);
>  	}
> -#endif
> 
>  	return rc;
>  }
> @@ -4117,17 +4111,13 @@ err:
>  static int __devexit mv_platform_remove(struct platform_device *pdev)
>  {
>  	struct ata_host *host = platform_get_drvdata(pdev);
> -#if defined(CONFIG_HAVE_CLK)
>  	struct mv_host_priv *hpriv = host->private_data;
> -#endif
>  	ata_host_detach(host);
> 
> -#if defined(CONFIG_HAVE_CLK)
>  	if (!IS_ERR(hpriv->clk)) {
>  		clk_disable(hpriv->clk);
>  		clk_put(hpriv->clk);
>  	}
> -#endif
>  	return 0;
>  }
