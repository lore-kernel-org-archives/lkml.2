Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0DSHjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 03:39:11 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:57807 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0DSHjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 03:39:06 -0400
Date: Mon, 19 Apr 2010 09:38:59 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       r.herring@freescale.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com
Subject: Re: [PATCHv4 2.6.34-rc4 5/7] mxc: Add generic USB HW
 initialization for MX51
Message-ID: <20100419073859.GA30801@buzzloop.caiaq.de>
References: <1271445371-18501-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-4-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-5-git-send-email-Dinh.Nguyen@freescale.com>
 <20100417170706.GY30801@buzzloop.caiaq.de>
 <20100419010340.GB15308@matterhorn.verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419010340.GB15308@matterhorn.verdurent.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 04:03:40AM +0300, Amit Kucheria wrote:
> On 10 Apr 17, Daniel Mack wrote:
> > > @@ -18,6 +19,7 @@
> > >  
> > >  #include <linux/platform_device.h>
> > >  #include <linux/io.h>
> > > +#include <linux/delay.h>
> > >  
> > >  #include <mach/hardware.h>
> > >  #include <mach/mxc_ehci.h>
> > > @@ -50,9 +52,14 @@
> > >  #define MX35_H1_TLL_BIT		(1 << 5)
> > >  #define MX35_H1_USBTE_BIT	(1 << 4)
> > >  
> > > -int mxc_set_usbcontrol(int port, unsigned int flags)
> > > +int mxc_intialize_usb_hw(int port, unsigned int flags)
> > 
> > This patch and the next one should be merged into one. The reason is
> > that you rename a function here and the next patch follows that change.
> > Especially when bisecting, this can lead to uncompilable checkouts of
> > the tree when stopping in the middle.
> 
> Also, patch 3 really belongs with this patch too since the #defines in
> patch 3 are used here.

Well, as long as the defines are commited _before_ their users, it
should be fine. But they can also be squashed into one, that's true.

Thanks,
Daniel

