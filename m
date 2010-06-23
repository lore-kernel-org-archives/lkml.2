Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab0FWNj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:39:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:60514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab0FWNj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:39:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,467,1272870000"; 
   d="scan'208";a="632882922"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       Alan Cox <alan@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jun 2010 19:09:12 +0530
Subject: RE: [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
Thread-Topic: [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
Thread-Index: AcsSbL0+DjH/Yh8wQ76zE0X7kDeAHQAbA6CA
Message-ID: <438BB0150E931F4B9CE701519A446301049B1BBE16@bgsmsx502.gar.corp.intel.com>
References: <20100618155149.1356.84206.stgit@localhost.localdomain>
 <AANLkTilvD6KKEY3GE2Q0q3z4gu6K6RwkMWbRaRPl9_pU@mail.gmail.com>
In-Reply-To: <AANLkTilvD6KKEY3GE2Q0q3z4gu6K6RwkMWbRaRPl9_pU@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [..]
> > ++ *    midc_do_start           begin a transaction
> > ++ *    @midc: channel
> > ++ *    @first: first descriptor of series
> > ++ *
> > ++ *    Load a transaction into the engine. This must be called with dwc->lock
> > ++ *    held and bh disabled.
> > ++ */
> > +static void midc_dostart(struct intel_mid_dma_chan *midc, struct
> intel_mid_dma_desc
> 
> (nit) The function name does not match the kernel doc, and I don't
> know if those extra "+" characters will throw off the kernel-doc
> scripts.  They also show up on midc_put_desc, but not
> midc_scan_descriptors.
Okay, will remove extra "+" char

> > +       /*tx is complete*/
> > +       list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
> > +               if (desc == NULL)
> > +                       continue;
> 
> How do we ever get desc == NULL at this point?
Yes we won't, will remove

> [..]
> > +#define _dma_printk(level, format, arg...)  \
> > +       printk(level "LNW_DMA: %s %d " format, __func__, __LINE__, ## arg)
> > +
> > +#ifdef CONFIG_LNW_DMA_DEBUG
> > +#define dma_dbg(format, arg...) _dma_printk(KERN_DEBUG, "DBG " format , ## arg)
> > +#else
> > +#define dma_dbg(format, arg...) do {} while (0);
> > +#endif
> 
> This makes us lose compile coverage of the debug statements so they
> bitrot until someone needs to debug a problem.
This was just for debug purposes, will be removed


 
> Any advantage to having a default callback in the slave configuration?
>  Why not let the client specify the callback on each operation, is it
> a callback that the client does not know about?
txd callback is enough, no need to keep here, will be removed

Thanks
Vinod
