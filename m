Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0FHHeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 03:34:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:5618 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0FHHeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 03:34:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,383,1272870000"; 
   d="scan'208";a="574285043"
Date: Tue, 8 Jun 2010 15:20:49 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Andrew <andrew.chih.howe.khor@intel.com>,
       Intel OTC <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Message-ID: <20100608072049.GA12940@ywang-moblin2.bj.intel.com>
References: <4C0DCE87.1090802@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0DCE87.1090802@dsn.okisemi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 02:00:55PM +0900, Masayuki Ohtak wrote:
> Hi Alan
> 
> We are now updating our Phub driver.
> 
> I have a questions for your comment.
> 
> (1)
> >> +#ifdef PCH_CAN_PCLK_50MHZ
> >> + /* save clk cfg register */
> >> + g_pch_phub_reg.clkcfg_reg = PCH_READ_REG(CLKCFG_REG_OFFSET);
> >> +#endif
> > 
> > This makes it hard to build one kernel for everything
> We couldn't understand your intention.
> Does the above mean we must not use "#ifdef PCH_CAN_PCLK_50MHZ"	in source code ?
> 

I think what Alan means is that you will have to build two kernel images
for two possible configurations of how your hardware is going to be used
if you write code this way. One is the case when CAN clock runs at 50MHz
and you will build a kernel image with PCH_CAN_PCLK_50MHZ defined. The
other is when CAN clock runs at other speed and you need to build
another kernel image with PCH_CAN_PCLK_50MHZ undefined. It would be much
better if one kernel image could run on all configurations.

Why is 50MHz so special, btw? Don't you need to save and restore the
clock config register when CAN clock runs at other speed?

> 
> >> +#define PCH_READ_REG(a) ioread32((pch_phub_base_address + a))
> 
> >> +
> 
> >> +#define PCH_WRITE_REG(a, b) iowrite32(a, (pch_phub_base_address + b))
> 
> > 
> 
> > These on the other hand do - but not where they are now
> 
> > 
> 
> > iowrite32((a), pcb_phub_base_address + (b))
> 
> > 
> 
> > (so that if a or b are expressions they are evaluated first)
> 
> Modify like below.
> 
> #define PCH_READ_REG(a) ioread32(pch_phub_base_address + (a))
> 
> #define PCH_WRITE_REG(a, b) iowrite32(a, pch_phub_base_address + (b))
> 

Note that 'a' is supposed to be surrounded by brackets, too.

#define PCH_WRITE_REG(a, b)	iowrite32((a), pcb_phub_base_address + (b))

Thanks
-Yong

