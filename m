Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1BOHBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 02:01:54 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:44357 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1BOHBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 02:01:53 -0500
Message-ID: <4D5A2591.5090901@wytron.com.tw>
Date: Tue, 15 Feb 2011 15:04:49 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ryan Mallon <ryan@bluewatersys.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v9] spi: New driver for Altera SPI
References: <1297142509-20158-1-git-send-email-thomas@wytron.com.tw> <1297649443-11491-1-git-send-email-thomas@wytron.com.tw> <4D58917E.9050408@bluewatersys.com>
In-Reply-To: <4D58917E.9050408@bluewatersys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ryan,

On 02/14/2011 10:20 AM, Ryan Mallon wrote:
> On 02/14/2011 03:10 PM, Thomas Chou wrote:
>> This patch adds a new SPI driver to support the Altera SOPC Builder
>> SPI component. It uses the bitbanging library.
>>
>> Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
>> ---
>
>> +struct altera_spi {
>> +	/* bitbang has to be first */
>> +	struct spi_bitbang bitbang;
>
> Is this still true? I had a quick look and can't see anything which
> relies on spi_bitbang being the first entry. Things like this should be
> using container_of so that position in the struct is irrelevant.
>
> ~Ryan
>

Yes, sadly true. This is due to the implementation of the bitbanging 
library, spi_bitbang.c, which assumes the struct spi_bitbang is the 
first of drvdata. Though it could be changed in the future (beyond this 
little driver), every bitbanging library user has to follow this for now.

Best regards,
Thomas
