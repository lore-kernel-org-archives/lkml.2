Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab1CMNvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 09:51:01 -0400
Received: from compulab.co.il ([67.18.134.219]:37308 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab1CMNu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 09:50:59 -0400
Message-ID: <4D7CCB10.50009@compulab.co.il>
Date: Sun, 13 Mar 2011 15:48:00 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH v3] pch_uart: reference clock on CM-iTC
References: <4D74A600.7070302@compulab.co.il> <20110307200733.GA18849@kroah.com> <4D761F7F.2030908@compulab.co.il> <20110309234238.GA4071@kroah.com> <4D78CE98.4040500@compulab.co.il> <20110311222529.GA14675@kroah.com>
In-Reply-To: <20110311222529.GA14675@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

There is a patch to pch_phub.c that is absent in your linux/kernel/git/gregkh/tty-2.6.git
pch_phub: add new device ML7213
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=c47dda7d179dde17697c3f839f150fecaf6770cb

>From which repository you want my patch to be based?

On 03/12/2011 12:25 AM, Greg KH wrote:
> On Thu, Mar 10, 2011 at 03:14:00PM +0200, Denis Turischev wrote:
>> Default clock source for UARTs on Topcliff is external UART_CLK.
>> On CM-iTC USB_48MHz is used instead. After VCO2PLL and DIV
>> manipulations UARTs will receive 192 MHz.
>> Clock manipulations on Topcliff are controlled in pch_phub.c
>>
>> v2: redone against the linux-next tree
>> v3: redone against linux/kernel/git/next/linux-next.git snapshot
>>
>> Signed-off-by: Denis Turischev <denis@compulab.co.il>
>> ---
>> diff -Nru linux-next-20110310.orig/drivers/misc/pch_phub.c linux-next-20110310/drivers/misc/pch_phub.c
>> --- linux-next-20110310.orig/drivers/misc/pch_phub.c	2011-03-10 08:31:30.000000000 +0200
>> +++ linux-next-20110310/drivers/misc/pch_phub.c	2011-03-10 14:42:05.110978473 +0200
>> @@ -618,6 +626,14 @@
>>  					       CLKCFG_CAN_50MHZ,
>>  					       CLKCFG_CANCLK_MASK);
>>
>> +		/* quirk for CM-iTC board */
>> +		if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
>> +			pch_phub_read_modify_write_reg(chip,
>> +						(unsigned int)CLKCFG_REG_OFFSET,
>> +						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
>> +						CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
>> +						CLKCFG_UART_MASK);
>> +
> 
> This is the chunk that is causing problems.  I guess someone else
> modified this file in the linux-next tree, and I can't apply it in mine.
> Any ideas who did this change?  Can you look at the linux-next tree and
> see what caused this merge issue?
> 
> thanks,
> 
> greg k-h


-- 
Denis
