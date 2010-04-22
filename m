Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0DVPCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:02:52 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:59046 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab0DVPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:02:51 -0400
Date: Thu, 22 Apr 2010 17:02:44 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       valentin.longchamp@epfl.ch, grant.likely@secretlab.ca,
       bryan.wu@canonical.com, amit.kucheria@canonical.com,
       Jun.Li@freescale.com, xiao-lizhang@freescale.com
Subject: Re: [PATCHv7 2.6.34-rc5 4/5] mxc: Add generic USB HW
 initialization for MX51
Message-ID: <20100422150244.GX30801@buzzloop.caiaq.de>
References: <1271862795-7986-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271862795-7986-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271862795-7986-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1271862795-7986-4-git-send-email-Dinh.Nguyen@freescale.com>
 <20100422144543.GU7882@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422144543.GU7882@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 04:45:43PM +0200, Sascha Hauer wrote:
> On Wed, Apr 21, 2010 at 10:13:14AM -0500, Dinh.Nguyen@freescale.com wrote:
> > @@ -191,6 +191,11 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
> >  		clk_enable(priv->ahbclk);
> >  	}
> >  
> > +	/* setup specific usb hw */
> > +	ret = mxc_initialize_usb_hw(pdev->id, pdata->flags);
> > +	if (ret < 0)
> > +		goto err_init;
> > +
> >  	/* set USBMODE to host mode */
> >  	temp = readl(hcd->regs + USBMODE_OFFSET);
> >  	writel(temp | USBMODE_CM_HOST, hcd->regs + USBMODE_OFFSET);
> > @@ -199,11 +204,6 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
> >  	writel(pdata->portsc, hcd->regs + PORTSC_OFFSET);
> >  	mdelay(10);
> >  
> > -	/* setup USBCONTROL. */
> > -	ret = mxc_set_usbcontrol(pdev->id, pdata->flags);
> > -	if (ret < 0)
> > -		goto err_init;
> 
> Has somebody tested if this works on other i.MXs? I remember it was quite
> difficult to get the correct order of initialization. I don't want to
> break this.

Yes, I tested it on a MX31LiteKit and it works fine, so I didn't
consider this critical.

> We should at least make a seperate patch from it so that anybody
> bisecting this only finds this change and not the i.MX51 support also
> added in this patch.

Good idea. However, I insisted to have this hunk in this one commit as
it follows a function rename (mxc_initialize_usb_hw vs.
mxc_set_usbcontrol). So if we want to have this seperate, we'd need one
intermediate step.

Daniel
