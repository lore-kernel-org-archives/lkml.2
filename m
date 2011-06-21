Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1FUABl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:01:41 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:41022 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab1FUABi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:01:38 -0400
Message-ID: <4DFFDF07.2010200@metafoo.de>
Date: Tue, 21 Jun 2011 02:00:07 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 3/8] regmap: Add SPI bus support
References: <20110620124608.GB31140@opensource.wolfsonmicro.com> <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1308574489-31322-3-git-send-email-broonie@opensource.wolfsonmicro.com> <4DFFD738.4090206@metafoo.de> <20110620234513.GC1905@opensource.wolfsonmicro.com>
In-Reply-To: <20110620234513.GC1905@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 01:45 AM, Mark Brown wrote:
> On Tue, Jun 21, 2011 at 01:26:48AM +0200, Lars-Peter Clausen wrote:
>> On 06/20/2011 02:54 PM, Mark Brown wrote:
> 
>>> +static int regmap_spi_read(struct device *dev,
>>> +			   const void *reg, size_t reg_size,
>>> +			   void *val, size_t val_size)
>>> +{
>>> +	struct spi_device *spi = to_spi_device(dev);
> 
>>> +	return spi_write_then_read(spi, reg, reg_size, val, val_size);
> 
>> spi_write_then_read will use a bounce buffer internally, since we already have
>> our own bounce buffer it is probably better to use the low-level spi interface
>> directly in this case.
> 
> I've got this horrible feeling that if we try that we'll discover that
> the reason the SPI API does this internally is just as valid here - if I
> remember correctly it's doing this due to restrictions on DMA from the
> stack and I'd strongly expect val to end up on the stack for registers.
> Or to look at it from the other point of view if we don't need the
> bounce buffers then why does spi_write_then_read() need them?

hm, right, I overlooked that val could be on the stack. I though we were always
using some kind of bounce buffer internally.
