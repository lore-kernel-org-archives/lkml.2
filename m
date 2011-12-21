Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1LUKvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:51:43 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51752 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1LUKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:51:40 -0500
Message-ID: <4EF1BA2F.9090304@ti.com>
Date: Wed, 21 Dec 2011 11:51:27 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (mfd
 tree related)
References: <20111221173301.1111dc371e11d5c7025f03ea@canb.auug.org.au>
In-Reply-To: <20111221173301.1111dc371e11d5c7025f03ea@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 12/21/2011 7:33 AM, Stephen Rothwell wrote:
> Hi all,
>
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/mfd/twl-core.c: In function 'twl_probe':
> drivers/mfd/twl-core.c:1212:22: error: 'TWL6030_IRQ_BASE' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1212:22: note: each undeclared identifier is reported only once for each function it appears in
> drivers/mfd/twl-core.c:1213:39: error: 'TWL6030_BASE_NR_IRQS' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1215:22: error: 'TWL4030_IRQ_BASE' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1216:39: error: 'TWL4030_BASE_NR_IRQS' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1218:3: error: implicit declaration of function 'irq_domain_add_simple' [-Werror=implicit-function-declaration]
>
> Caused by commit 4eea8b1d717d ("mfd: Add initial DT support for
> twl4030/twl6030").  A missing include?  Or a CONFIG problem?

Both in fact...

There are some nasty dependencies with that TWL driver and the IRQ 
defined in OMAP headers only. I was fooled by the name of these macros.
I naively thought this could be fixed later as written in the comment I 
added. I appears this is not the case :-(.

> This build does not have CONFIG_IRQ_DOMAIN set.

Ooops, I was not aware of that domain CONFIG. That one is an easy fix.


Samuel,

Just let me know if you will have time for an updated version before Xmas.
I'll try to fix that by using irq_alloc_descs to avoid these hard-coded 
macros. It might conflict with the still hard coded GPIO IRQs range, but 
I'll see if it work for DT only at least.


Thanks,
Benoit

