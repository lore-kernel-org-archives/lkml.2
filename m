Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1BOJNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:13:15 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:3381 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754245Ab1BOJNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:13:08 -0500
Message-ID: <4D5A4396.9080003@bluewatersys.com>
Date: Tue, 15 Feb 2011 22:12:54 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Chou <thomas@wytron.com.tw>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v9] spi: New driver for Altera SPI
References: <1297142509-20158-1-git-send-email-thomas@wytron.com.tw> <1297649443-11491-1-git-send-email-thomas@wytron.com.tw> <4D58917E.9050408@bluewatersys.com> <4D5A2591.5090901@wytron.com.tw>
In-Reply-To: <4D5A2591.5090901@wytron.com.tw>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/11 20:04, Thomas Chou wrote:
> Dear Ryan,
> 
> On 02/14/2011 10:20 AM, Ryan Mallon wrote:
>> On 02/14/2011 03:10 PM, Thomas Chou wrote:
>>> This patch adds a new SPI driver to support the Altera SOPC Builder
>>> SPI component. It uses the bitbanging library.
>>>
>>> Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
>>> ---
>>
>>> +struct altera_spi {
>>> +    /* bitbang has to be first */
>>> +    struct spi_bitbang bitbang;
>>
>> Is this still true? I had a quick look and can't see anything which
>> relies on spi_bitbang being the first entry. Things like this should be
>> using container_of so that position in the struct is irrelevant.
>>
>> ~Ryan
>>
> 
> Yes, sadly true. This is due to the implementation of the bitbanging
> library, spi_bitbang.c, which assumes the struct spi_bitbang is the
> first of drvdata. Though it could be changed in the future (beyond this
> little driver), every bitbanging library user has to follow this for now.

Hmm, I see how it works now. Shouldn't the conversion be done like this:

  struct spi_bitbang *bitbang = spi_master_get_devdata(master);
  struct altera_spi *altera = container_of(bitbang,
				 struct altera_spi, bitbang);

Which doesn't require the bitbang field to be the first in the struct
and makes it more clear what is actually going on. The above could be
wrapped into a to_altera_spi macro.

~Ryan


