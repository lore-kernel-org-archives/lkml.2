Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0HJAd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 20:33:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:41198 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153Ab0HJAdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 20:33:20 -0400
Subject: Re: i386 allmodconfig, current mainline
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Mike Frysinger <vapier@gentoo.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Faisal Latif <faisal.latif@intel.com>,
        Chien Tung <chien.tin.tung@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org, x86@kernel.org,
        linux-rdma@vger.kernel.org
In-Reply-To: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
References: <20100809164346.6e30cf8c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 01:32:32 +0100
Message-ID: <1281400352.7143.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 16:43 -0700, Andrew Morton wrote:
> 
> drivers/power/olpc_battery.c:387: error: unknown field 'owner' specified in initializer
> drivers/power/olpc_battery.c:387: warning: initialization from incompatible pointer type
> make[2]: *** [drivers/power/olpc_battery.o] Error 1
> make[1]: *** [drivers/power] Error 2

I fixed that today.

> drivers/mtd/maps/gpio-addr-flash.c: In function 'gpio_flash_probe':
> drivers/mtd/maps/gpio-addr-flash.c:212: warning: cast to pointer from integer of different size
> drivers/mtd/maps/gpio-addr-flash.c:224: warning: cast to pointer from integer of different size

Ew. Mike? Is this a nommu driver which is missing an ioremap()? 

> drivers/pci/intel-iommu.c: In function 'dma_pte_addr':
> drivers/pci/intel-iommu.c:239: warning: passing argument 1 of '__cmpxchg64' from incompatible pointer type

-       return  __cmpxchg64(pte, 0ULL, 0ULL) & VTD_PAGE_MASK;
+       return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;

Will test and push.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

