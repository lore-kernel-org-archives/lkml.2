Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2I0O2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:28:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:29739 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2I0O2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:28:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,496,1344236400"; 
   d="scan'208";a="149854834"
Subject: Re: [PATCHv2 2/4] dmaengine: dw_dmac: Add PCI part of the driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: viresh kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        spear-devel <spear-devel@list.st.com>
In-Reply-To: <201209270741.54443.arnd@arndb.de>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <201209261941.11944.arnd@arndb.de>
	 <CAOh2x=kKYsvYKqpJ6EUpv_OL5f6OsvyS0Lq9yO2uouPPSXSgvw@mail.gmail.com>
	 <201209270741.54443.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 19:52:36 +0530
Message-ID: <1348755756.1648.33.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 07:41 +0000, Arnd Bergmann wrote:
> On Thursday 27 September 2012, viresh kumar wrote:
> > I believe there is no common initialization part here, because PCI device in any
> > case would be calling probe of platform device. :)
> 
> Looking at the driver more closely now. Right now, it only supports platform 
> devices, and the dw_probe function contains some parts that are related to
> platform devices and some parts that are needed also in case of PCI.
> 
> My suggestion would be that you split the dw_probe function to separate out
> the bus specific parts and end up with three functions like
> 
> int dw_dmac_probe(struct dw_dma *dw);
> int dw_dmac_platform_probe(struct platform_device *pdev);
> int dw_dmac_pci_probe(struct dw_dma *dw);
yes and bus probe shoudl aquire resources, other stuff should be done in
dmac_probe.
> 
> where the first one is called by the other two, depending on the bus type.
> This could be done either splitting the driver into multiple files so you can
> have the platform and pci parts in separate driver modules depending on the
> common module that does all the actual work, or everything can be put in
> a single file with an #ifdef CONFIG_PCI to disable the pci driver parts
> when they don't apply.
probe wont be called if PCI device is not loaded, so see no reason why
CONFIG_xxx would be needed
> 
> Does this make sense?
Yup!
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

