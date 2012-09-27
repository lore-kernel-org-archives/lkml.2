Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab2I0OWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:22:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2I0OWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:22:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: viresh kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCHv2 2/4] dmaengine: dw_dmac: Add PCI part of the driver
Date: Thu, 27 Sep 2012 07:41:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "spear-devel" <spear-devel@list.st.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com> <201209261941.11944.arnd@arndb.de> <CAOh2x=kKYsvYKqpJ6EUpv_OL5f6OsvyS0Lq9yO2uouPPSXSgvw@mail.gmail.com>
In-Reply-To: <CAOh2x=kKYsvYKqpJ6EUpv_OL5f6OsvyS0Lq9yO2uouPPSXSgvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209270741.54443.arnd@arndb.de>
X-Provags-ID: V02:K0:DknzYCTZV2tIRJ0aQLiPXekZTo/a8MjOWG1LH+M1/MY
 vsxfOJqNR6Et2GoXNL7OXweDesRQyc43u4PuzoYuaNODCuTpWC
 uQpRAuPZd2+gK5wLz2vRaBlVHekrzoe8d9ZEWqDU97zLN3/LmD
 2lIOBiDBlMqyElCnqL/3MHPBMh8n6+D/Mdoi/Uw+wOPaGcHr4W
 ogqygovbhazAC3RNOCoHPvY6c7I/xNjYScjhZuFuWKWHhNi7/0
 PWoeXmqcm/h2fFxpErCB1w/J74vGpVMeKz0NlfAMq0KINB7gG+
 J6m6Cacysd9SnOAoid5p5D63mHA4U/HUyZetGMQHNEVLAgotf8
 uOpSDORLziWlRgyqM578=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2012, viresh kumar wrote:
> I believe there is no common initialization part here, because PCI device in any
> case would be calling probe of platform device. :)

Looking at the driver more closely now. Right now, it only supports platform 
devices, and the dw_probe function contains some parts that are related to
platform devices and some parts that are needed also in case of PCI.

My suggestion would be that you split the dw_probe function to separate out
the bus specific parts and end up with three functions like

int dw_dmac_probe(struct dw_dma *dw);
int dw_dmac_platform_probe(struct platform_device *pdev);
int dw_dmac_pci_probe(struct dw_dma *dw);

where the first one is called by the other two, depending on the bus type.
This could be done either splitting the driver into multiple files so you can
have the platform and pci parts in separate driver modules depending on the
common module that does all the actual work, or everything can be put in
a single file with an #ifdef CONFIG_PCI to disable the pci driver parts
when they don't apply.

Does this make sense?

	Arnd
