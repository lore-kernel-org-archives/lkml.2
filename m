Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1DUIIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:08:38 -0400
Received: from smtp-out-095.synserver.de ([212.40.185.95]:1107 "HELO
	smtp-out-087.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753275Ab1DUIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:08:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 8285
Message-ID: <4DAFE62A.105@metafoo.de>
Date: Thu, 21 Apr 2011 10:09:14 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: linux-kernel@vger.kernel.org, "'Grant Likely'" <grant.likely@secretlab.ca>,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: Question: GPIO driver how to get irq_base
References: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com>
In-Reply-To: <F9B588C24C5F470494D57D4EFFB14C6B@hacdom.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 09:32 AM, Tomoya MORINAGA wrote:
> Hi GPIO maintainer,
> 
> Need your help.
> I want to add interrupt function to gpio/pch_gpio.c
> 
> According to other upstreamed GPIO driver, (e.g. pl061, langwell, etc...)
> 2 IRQs(irq, irq_base) are used.
> 
> I can get "irq" from (struct pci_dev *)pdev->irq.
> However I can't understand where can I get the "irq_base".
> Let me know how to get.
> 
> Thanks,
> -----------------------------------------
> Tomoya MORINAGA
> OKI SEMICONDUCTOR CO., LTD.

In my opinion the best option for expander chips is to allocate a new irq_desc
range by calling irq_alloc_descs. It will return the first irq number in the
newly allocated range, which will be your irq_base.
But be aware that this will require SPARSE_IRQ to work.

- Lars
