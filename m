Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912Ab2FHIwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:52:00 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:35382 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760567Ab2FHIv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:51:57 -0400
Message-ID: <4FD1BD2B.6090200@ti.com>
Date: Fri, 08 Jun 2012 11:51:55 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120605 Thunderbird/12.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, t-kristo@ti.com,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] MFD: twl6040: Update Kconfig to avoid build breakage
References: <1339137300-16546-1-git-send-email-peter.ujfalusi@ti.com> <20120608083003.GI22557@sortiz-mobl>
In-Reply-To: <20120608083003.GI22557@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On 06/08/2012 11:30 AM, Samuel Ortiz wrote:

> Hi Peter,
> 
> On Fri, Jun 08, 2012 at 09:35:00AM +0300, Peter Ujfalusi wrote:
>> twl6040 needs CONFIG_IRQ_DOMAIN to compile, without this we have:
>> drivers/mfd/twl6040-irq.c: In function 'twl6040_irq_init':
>> drivers/mfd/twl6040-irq.c:164:2: error: implicit declaration of function 'irq_domain_add_legacy'
>> drivers/mfd/twl6040-irq.c:165:11: error: 'irq_domain_simple_ops' undeclared (first use in this function)
>> drivers/mfd/twl6040-irq.c:165:11: note: each undeclared identifier is reported only once for each function it appears in
>>
>> Reported by: Randy Dunlap <rdunlap@xenotime.net>
>>
>> At the same time limit the twl6040 availability to ARM architecture since
>> it is unlikely that this chip is going to be used on other architectures.
> Right, but you're losing a lot of the linux-next build coverage.
> With a dependency on ARM, we may have missed the above build error for
> example. Would you mind removing that dependency ?


Yes. True that we miss some coverage due to depending on ARM here. I did
missed this since when I build for OMAP the IRQ_DOMAIN is selected by OF,
which is selected by OMAP. Even if I use randconfig for ARM I would not
noticed this since AFAIK ARM selects IRQ_DOMAIN also...

I'll resend in a minute without the ARM dependency.

-- 
Péter
