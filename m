Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1AGGkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:40:40 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:27271 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060Ab1AGGkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:40:39 -0500
From: "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Tomoya MORINAGA'" <tomoya-linux@dsn.okisemi.com>
Cc: "'David Brownell'" <dbrownell@users.sourceforge.net>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <qi.wang@intel.com>,
        <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>,
        "'Toshiharu Okada'" <toshiharu-linux@dsn.okisemi.com>
References: <1293449027-3219-1-git-send-email-tomoya-linux@dsn.okisemi.com> <20101229064937.GC8172@angua.secretlab.ca> <280596192AA74D208C2C5F6389DBE8C1@hacdom.okisemi.com> <20110105163835.GD17272@angua.secretlab.ca>
Subject: RE: [PATCH 1/3] spi_topcliff_pch: support new device ML7213
Date: Fri, 7 Jan 2011 15:40:35 +0900
Message-ID: <46862922F48B45F781832619CF3F4B79@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acus9wTxGz7KrmkJRQuS/bs2aL5tZABPXutA
In-Reply-To: <20110105163835.GD17272@angua.secretlab.ca>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thursday, January 06, 2011 1:39 AM, Grant Likely wrote:
> As far as examples go, drivers/mfd/timberdale.c seems 
> reasonable, if a bit larger than what you need.

Thank you for your suggestion.
However, though seeing this driver, I didn't understand your intention.
It seems platform_device/platform_driver are not used in this.
Which part of this driver do you want to show me as reference ?

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

> -----Original Message-----
> From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of 
> Grant Likely
> Sent: Thursday, January 06, 2011 1:39 AM
> To: Tomoya MORINAGA
> Cc: David Brownell; spi-devel-general@lists.sourceforge.net; 
> linux-kernel@vger.kernel.org; qi.wang@intel.com; 
> yong.y.wang@intel.com; joel.clark@intel.com; 
> kok.howg.ewe@intel.com; Toshiharu Okada
> Subject: Re: [PATCH 1/3] spi_topcliff_pch: support new device ML7213
> 
> On Wed, Jan 05, 2011 at 11:34:20AM +0900, Tomoya MORINAGA wrote:
> > Hi Grant,
> > 
> > On Wednesday, December 29, 2010 3:49 PM, Grant Likely wrote:
> > >As previously discussed on this list, I would like to see 
> support for 
> > >multiple bus instances implemented differently.  Rather 
> than storing 
> > >the spi_master instances in an array in the pci device 
> private data, 
> > >the pci device should register a separate platform_device for each 
> > >spi bus instance, and each of those bus instances should 
> get bound to 
> > >a topcliff_spi_bus driver which doesn't need to have any special 
> > >knowledge about how many spi_master instances actually exist.
> > >
> > >Basically, the way it is implemented in this patch isn't taking 
> > >advantage of the infrastructure and instance management 
> provided by 
> > >the driver model.
> > 
> > I see.
> > I will modify like your suggestion.
> > Could you show the reference SPI driver using multi-instance ?
> 
> In an multi-instance scenario, the spi driver is just a 
> plain-jane platform_driver.  There isn't anything special 
> about it.  Instead, the pci_driver becomes responsible to 
> register one or more platform devices for the child busses.  
> Much like one of the multifunction devices in drivers/mfd.
> 
> As far as examples go, drivers/mfd/timberdale.c seems 
> reasonable, if a bit larger than what you need.
> 
> g.
> 
> > 
> > Thanks,
> > ---
> > Tomoya MORINAGA
> > OKI SEMICONDUCTOR CO., LTD.
> > 
> 

