Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1FSMLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 08:11:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64366 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1FSMLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 08:11:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] net/fec: add device tree support
Date: Sun, 19 Jun 2011 14:11:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Greg Ungerer <gerg@snapgear.com>, Shawn Guo <shawn.guo@linaro.org>,
        patches@linaro.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Jason Liu <jason.hui@linaro.org>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org> <1308410354-21387-3-git-send-email-shawn.guo@linaro.org> <4DFDDFF4.8000305@snapgear.com>
In-Reply-To: <4DFDDFF4.8000305@snapgear.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106191411.32137.arnd@arndb.de>
X-Provags-ID: V02:K0:dcbs8u4KlxAXYmytWpcZU6hWrGnBFI7kYSeOeNMDeb7
 w7gIxEo9mzSjKYBHf3MjLOzNRvxG1igvNUdpoUbrtpmDzR7Ske
 O3q9ZRQHV+v77dyFKgmDOeO620w/1Gpx0jrv8EvCrYeqbnGS2J
 +zw1xRVNgJtyVOwM1WB2a4a3Xu0zManSqJx2qnO84I78t88Kik
 fKuwSYKOOI1SEUFFpxepg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 13:39:32 Greg Ungerer wrote:
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id fec_dt_ids[] = {
> > +     { .compatible = "fsl,fec", .data =&fec_devtype[0], },
> > +     {},
> > +};
> > +
> > +static const struct of_device_id *
> > +fec_get_of_device_id(struct platform_device *pdev)
> > +{
> > +     return of_match_device(fec_dt_ids,&pdev->dev);
> > +}
> > +#else
> > +#define fec_dt_ids NULL
> > +static inline struct of_device_id *
> > +fec_get_of_device_id(struct platform_device *pdev)
> > +{
> > +     return NULL;
> > +}
> > +#endif
> > +
> >   static unsigned char macaddr[ETH_ALEN];
> >   module_param_array(macaddr, byte, NULL, 0);
> >   MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
> > @@ -1363,6 +1385,11 @@ fec_probe(struct platform_device *pdev)
> >       struct net_device *ndev;
> >       int i, irq, ret = 0;
> >       struct resource *r;
> > +     const struct of_device_id *of_id;
> > +
> > +     of_id = fec_get_of_device_id(pdev);
> 
> fec_get_of_device_id() is defined inside of "#ifdef CONFIG_OF". This
> use of it will break compilation when this is not defined.
> 


Why? Note the #else path defining an empty function.

	Arnd
