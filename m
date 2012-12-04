Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2LDP2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:28:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:53337 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab2LDP2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:28:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="251773862"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: RE: [char-misc-next 07/15] mei: use wrietl/readl instead of io
 wrappers
Thread-Topic: [char-misc-next 07/15] mei: use wrietl/readl instead of io
 wrappers
Thread-Index: AQHN0ihwqEeZmpNWmk6M50CYz937qJgIklqAgAArpVA=
Date: Tue, 4 Dec 2012 15:28:23 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01E9DED6@HASMSX106.ger.corp.intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
	<1354629884-3202-7-git-send-email-tomas.winkler@intel.com>
 <20121204143151.1cce530a@pyramind.ukuu.org.uk>
In-Reply-To: <20121204143151.1cce530a@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >  /**
> > @@ -451,7 +451,7 @@ static inline u32 mei_reg_read(const struct
> > mei_device *dev,  static inline void mei_reg_write(const struct mei_device
> *dev,
> >  				 unsigned long offset, u32 value)  {
> > -	iowrite32(value, dev->mem_addr + offset);
> > +	writel(value, dev->mem_addr + offset);
> 
> ioremap should match readl/writel
> iomap iowrite32/ioread32

Thanks, I can replace pci_iomap with pci_ioremap_bar although in low level it is doing just the same.


> so you need to tweak the map/unmap if you do this.
> 
> As to overhead. I'd love to see a measurement that can detect the
> difference. Do you have a benchmark that shows it ?

Don't have any numbers but it seems reasonable to me.
 I did following this example

commit 05f5b97ee0013fefbd9139cf8c3eda5f2a88c04a
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Wed Mar 7 09:52:26 2012 -0800
 
    iwlwifi: use writeb,writel,readl directly
    
    That change will save us some CPU cycles at run time. Having port-based
    I/O seems to be not possible for PCIe devices.
    
    Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks
Tomas

