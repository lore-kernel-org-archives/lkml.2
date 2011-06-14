Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1FNMN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:13:26 -0400
Received: from smtp.nokia.com ([147.243.1.48]:41112 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab1FNMNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:13:22 -0400
Subject: Re: [RFC PATCHv5 2/7] HSI: omap_ssi: Introducing OMAP SSI driver
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <20110613132152.GA3352@atomide.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	 <1307713124-3946-3-git-send-email-carlos.chinea@nokia.com>
	 <20110613132152.GA3352@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 15:09:22 +0300
Message-ID: <1308053362.2819.38112.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
-- cut--
> > +
> > +static int __init ssi_init(void)
> > +{
> > +	return platform_device_register(&ssi_pdev);
> > +}
> > +subsys_initcall(ssi_init);
> 
> Looks like you need something here also to prevent this subsys_initcall
> on running on all boards. Maybe have a pointer to ssi_pdev that only
> gets initialized after omap_ssi_config?
> 
> Then you can have ssi_init fail if no configuration is called:
> 
> 	if (!pdev)
> 		return -ENODEV;
> 
> 	return platform_device_register(pdev);
> 

Right. I'll do those changes.

Thanks,
Carlos

