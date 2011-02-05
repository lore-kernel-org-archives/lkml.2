Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1BENHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 08:07:49 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:46689 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1BENHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 08:07:48 -0500
Message-ID: <4D4D4BD6.3040909@wytron.com.tw>
Date: Sat, 05 Feb 2011 21:08:38 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v6] spi: New driver for Altera SPI
References: <1295851114-12488-1-git-send-email-thomas@wytron.com.tw> <1296727326-2581-1-git-send-email-thomas@wytron.com.tw> <20110203173430.GC6180@angua.secretlab.ca>
In-Reply-To: <20110203173430.GC6180@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2011 01:34 AM, Grant Likely wrote:
> Hi Thomas, comments below, but looking pretty close.

Thanks a lot.

>> +config SPI_ALTERA
>> +	tristate "Altera SPI Controller"
>> +	select SPI_BITBANG
>
> Will this compile on all architectures?  Will it break allyesconfig
> on anything other than nios?

Yes, it compile on other architectures. I will add 'default n' though.

There are soft-core arm, mips and coldfire running on altera fpga. 
Others might use fpga as peripheral extender, too. So we shouldn't limit 
it to nios2.

>> +static int __init altera_spi_init(void)
>> +{
>> +	return platform_driver_probe(&altera_spidrv, altera_spi_probe);
>
> platform_driver_register() please, and put the altera_spi_probe()
> routine into the driver structure.

I will change it to register as you suggested.

- Thomas
