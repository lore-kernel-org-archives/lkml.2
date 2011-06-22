Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab1FVTWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:22:07 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:46168 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932437Ab1FVTWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:22:04 -0400
Message-ID: <4E024089.9040204@metafoo.de>
Date: Wed, 22 Jun 2011 21:20:41 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register access
 API
References: <20110622184407.GC13847@sirena.org.uk> <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com> <4E023C72.3030109@metafoo.de> <20110622191145.GA19628@opensource.wolfsonmicro.com>
In-Reply-To: <20110622191145.GA19628@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 09:11 PM, Mark Brown wrote:
> On Wed, Jun 22, 2011 at 09:03:14PM +0200, Lars-Peter Clausen wrote:
>> On 06/22/2011 08:45 PM, Mark Brown wrote:
> 
>>> +	if (map->bus->read_flag_bit)
>>> +		u8[0] |= 1 << map->bus->read_flag_bit;
> 
>> Should be 1 << (map->bus->read_flag_bit - 1)
> 
> The code has the sematic I intended; you can debate if it's the best
> semantic and looking at the documentation again it's not entirely clear
> so at least that should be updated.

Well, then the spi regmap driver needs to use read_flag_bit = 7 instead of
read_flag_bit = 8 and the BUG_ON should also be updated to read_flag_bit >= 8.

And the current code also disallows to use the first bit as the read_flag. So
in my opinion using a one-based index here is a good idea.

> BTW, the reason I put you on the CCs was the hope that you could test on
> OpenMoko (I have one but I've not got any kind of working environment
> set up for it).  You're the nearest thing to a mainline maintainer for
> stuff like the pcf driver.

It's already on my todo list.

