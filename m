Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab0G1Ivx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 04:51:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34940 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0G1Ivu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 04:51:50 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 28 Jul 2010 10:53:17 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <20100727120841.GC11468@n2100.arm.linux.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Walker <dwalker@codeaurora.org>, Jonathan Corbet <corbet@lwn.net>,
        Pawel Osciak <p.osciak@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Hiremath Vaibhav <hvaibhav@ti.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <op.vgjpm3it7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <cover.1280151963.git.m.nazarewicz@samsung.com>
 <743102607e2c5fb20e3c0676fadbcb93d501a78e.1280151963.git.m.nazarewicz@samsung.com>
 <dc4bdf3e0b02c0ac4770927f72b6cbc3f0b486a2.1280151963.git.m.nazarewicz@samsung.com>
 <20100727120841.GC11468@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static inline dma_addr_t __must_check
>> +cma_alloc(const struct device *dev, const char *kind,
>> +	  size_t size, dma_addr_t alignment)
>> +{
>> +	return dev ? -EINVAL : __cma_alloc(dev, kind, size, alignment);

On Tue, 27 Jul 2010 14:08:41 +0200, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> So I can't use this to allocate memory for anything but a NULL device?

>> +static inline int
>> +cma_info(struct cma_info *info, const struct device *dev, const char *kind)
>> +{
>> +	return dev ? -EINVAL : __cma_info(info, dev, kind);

> This won't return information for anything but a NULL device?

Obviously a bug.  Thanks for spotting that.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
