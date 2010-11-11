Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab0KKLih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:38:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48433 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab0KKLig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J6p/T+PVetgNhm9Hkn157zTlz22yXdKS5HkX8mWVV4NfJHQfNKHlhu5cFo9o5d2dAG
         5XHj97iax9edTVnnMRtBgSRh1aKW19Um4+eq2Ifs+ucy+ZCJyoAlJsmhw/Unnx1dsOWJ
         O6FItvPuP8uN4xQqqUwagl9u8DhkSwrk0M6RE=
Message-ID: <4CDBD91A.2010805@gmail.com>
Date: Thu, 11 Nov 2010 03:52:58 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 4/6] ce4100: Add errata fixes for UART on CE4100
References: <cover.1289331834.git.dirk.brandewie@gmail.com> <395c11879580e72e3a47272ef8cf5e04fa334210.1289331834.git.dirk.brandewie@gmail.com> <alpine.LFD.2.00.1011111231430.2900@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1011111231430.2900@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 03:34 AM, Thomas Gleixner wrote:
>
>
>> +	 * Over ride the legacy port configuration that comes from
>> +	 * asm/serial.h. Using the ioport driver then switching to the
>> +	 * PCI memmaped driver hangs the IOAPIC
>> +	 */
>> +	if (up->iotype !=  UPIO_MEM32) {
>> +		up->uartclk  = 14745600;
>> +		up->mapbase = 0xdffe0200;
>
>    What does the uartclk, mapbase fixups in the CONFIG_EARLY_PRINTK=n case ?
>
This is setup in the PCI driver patch #3 in the series

>> +		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE,
>> +				up->mapbase&  PAGE_MASK);
>> +		up->membase =
>> +			(void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
>> +		up->membase += up->mapbase&  ~PAGE_MASK;
>> +		up->iotype   = UPIO_MEM32;
>> +		up->regshift = 2;
>> +	}
>> +#endif
>> +	up->iobase = 0;
>> +	up->serial_in = ce4100_mem_serial_in;
>> +	up->serial_out = ce4100_mem_serial_out;
>> +
>> +	*capabilites |= (1<<  12);
>> +}
>
> Thanks,
>
> 	tglx

