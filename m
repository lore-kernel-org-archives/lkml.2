Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965599Ab2EOP4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:56:37 -0400
Received: from antcom.de ([188.40.178.216]:57302 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab2EOP4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:56:36 -0400
Message-ID: <4FB27CB0.8000308@antcom.de>
Date: Tue, 15 May 2012 17:56:32 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MTD: LPC32xx MLC NAND driver
References: <1337091832-10138-1-git-send-email-stigge@antcom.de> <20120515143428.GC13860@n2100.arm.linux.org.uk> <4FB27B24.3030604@antcom.de>
In-Reply-To: <4FB27B24.3030604@antcom.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 05:49 PM, Roland Stigge wrote:
>>> +
>>> +	sg_init_one(&host->sgl, mem, len);
>>> +
>>> +	res = dma_map_sg(host->dma_chan->device->dev, &host->sgl, 1, dir);
>>
>> Also note that dma transfer directions and dma data directions are
>> different things.  You shouldn't mix the two.

Can I safely use DMA_BIDIRECTIONAL here (practically, it works - just
tested), because the caller asks for read _or_ write? Or do I need to
formally convert enum dma_transfer_direction to enum dma_data_direction?

Thanks in advance,

Roland
