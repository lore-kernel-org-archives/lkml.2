Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab0CYJco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:32:44 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:39126 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab0CYJcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:32:43 -0400
To: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
MIME-Version: 1.0
Date: Thu, 25 Mar 2010 10:32:37 +0100
From: Marc Zyngier <maz@misterjones.org>
Cc: <dan.j.williams@intel.com>, <linus.ml.walleij@gmail.com>,
       <kyungmin.park@samsung.com>, <linux-kernel@vger.kernel.org>,
       <linux-arm-kernel@lists.infradead.org>
Organization: Metropolis
In-Reply-To: <4BAB264C.2090502@samsung.com>
References: <4BAAD5BB.7050101@samsung.com> <20100325054430.165311fa@taxman.wild-wind.fr.eu.org> <4BAB264C.2090502@samsung.com>
Message-ID: <960f4547118a62d5863ee38ba760844c@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: jy0922.shim@samsung.com, dan.j.williams@intel.com, linus.ml.walleij@gmail.com, kyungmin.park@samsung.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Mar 2010 18:01:00 +0900, Joonyoung Shim
<jy0922.shim@samsung.com> wrote:
> On 3/25/2010 2:44 PM, Marc Zyngier wrote:
>> On Thu, 25 Mar 2010 12:17:15 +0900
>> Joonyoung Shim <jy0922.shim@samsung.com> wrote:
>> 
>>> +	writew(imm, desc_pool_virt);
>> 
> 
> Right. The write[bwl] is api for address ioremapped of io device. I will
> change these.
> 
>> Does anything ensure that this won't generate an unaligned access?
>> 
> 
> PL330 DMA controller fetches variable length instructions that consist
of
> one to six bytes, so i think unaligned access is no problem.

I'm not too concerned about the device side of things. I'm more worried
about the CPU access when writing the 'imm' value to memory.

Consider desc_pool_virt 16bit aligned when entering the function. Writing
the opcode makes it unaligned and then writing the 'imm' value will result
as an unaligned access.

        M.
-- 
Who you jivin' with that Cosmik Debris?
