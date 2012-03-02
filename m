Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2CBRIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:08:35 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:27018 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab2CBRId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:08:33 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/9yetBYNE+nLhTpQL1FOta
Date: Fri, 2 Mar 2012 09:08:30 -0800
From: Tony Lindgren <tony@atomide.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] mmc: omap_hsmmc: Use gpio_find_by_chip_name() for
 omap_hsmmc_gpio_init()
Message-ID: <20120302170830.GH18901@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <20120301185528.29210.85854.stgit@kaulin.local>
 <4F5075EE.1050902@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5075EE.1050902@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rajendra Nayak <rnayak@ti.com> [120301 22:54]:
> On Friday 02 March 2012 12:25 AM, Tony Lindgren wrote:
> >+		if (slot->gpiochip_cd) {
> >+			pr_warning("MMC %s card detect GPIO chip %s unavailable\n",
> >+				slot->name, slot->gpiochip_cd);
> >+			ret = -ENODEV;
> >+			goto err_free_sp;
> 
> This should just return -ENODEV, nothing really to free here.

Thanks, will correct.
 
> >@@ -2093,8 +2123,7 @@ err1:
> >  	platform_set_drvdata(pdev, NULL);
> >  	mmc_free_host(mmc);
> >  err_alloc:
> >-	omap_hsmmc_gpio_free(pdata);
> >-err:
> >+	omap_hsmmc_gpio_free(host);
> 
> This error handling needs to be fixed up. In case
> omap_hsmmc_gpio_init() fails, which already frees up
> any requested gpios, omap_hsmmc_gpio_free() again tries
> freeing gpios.

Hmm that sounds like a separate patch that should be a fixed
before this series?

Regards,

Tony
