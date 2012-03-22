Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab2CVKRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:17:15 -0400
Received: from metasoft.pl ([195.149.224.191]:33394 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab2CVKRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:17:12 -0400
X-clamdmail: clamdmail 0.18a
Message-ID: <4F6AFC19.9040003@metasoft.pl>
Date: Thu, 22 Mar 2012 11:16:57 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
References: <4F683B36.8090101@metasoft.pl> <ADE657CA350FB648AAC2C43247A983F0020696D488E3@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020696D488E3@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-21 18:12, H Hartley Sweeten wrote:
> Hmm... This isn't working on my ep9307 board...
> 
> When the system boots I get stormed with messages:
> 
> dma dma1chan0: unknown interrupt!
> dma dma1chan0: unknown interrupt!
> dma dma1chan0: unknown interrupt!
> dma dma1chan1: unknown interrupt!
> dma dma1chan1: unknown interrupt!
> dma dma1chan1: unknown interrupt!
> dma dma1chan0: unknown interrupt!
> dma dma1chan0: unknown interrupt!
> dma dma1chan1: unknown interrupt!
> 
> Note, I have use_dma set for the ep93xx_spi driver and am using mmc_spi.

Thanks for testing. Unfortunately, I'm unable to test this patch with SPI,
because my hardware uses it only for very simple communication (one byte
commands, I noticed that DMA is not used in this case, even if enabled).

In current mainline I also get these messages:

dma dma1chan0: unknown interrupt!
dma dma1chan1: got interrupt while active list is empty

With my patch applied they happen more often (maybe because NFB interrupt
is enabled), but the system is usable. Changing kernel to 3.2.x or using
hack proposed by Mika makes the problem is gone.

