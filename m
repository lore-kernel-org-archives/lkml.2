Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1LBAF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:05:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:38072 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab1LBAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:05:23 -0500
Message-ID: <4ED81632.3030809@windriver.com>
Date: Thu, 1 Dec 2011 19:05:06 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: <gregkh@suse.de>, <alan@linux.intel.com>, <galak@kernel.crashing.org>,
        <linux-serial@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] 8250: add workaround for MPC8[356]xx UART break IRQ
 storm
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com> <1322783258-20443-4-git-send-email-paul.gortmaker@windriver.com> <4ED812E4.60905@freescale.com>
In-Reply-To: <4ED812E4.60905@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-01 06:51 PM, Scott Wood wrote:
> On 12/01/2011 05:47 PM, Paul Gortmaker wrote:
>> diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
>> index 8c660af..b0f4042 100644
>> --- a/include/linux/serial_8250.h
>> +++ b/include/linux/serial_8250.h
>> @@ -18,6 +18,11 @@
>>  #define UART_BUG_TXEN	(1 << 1)	/* buggy TX IIR status */
>>  #define UART_BUG_NOMSR	(1 << 2)	/* buggy MSR status bits (Au1x00) */
>>  #define UART_BUG_THRE	(1 << 3)	/* buggy THRE reassertion */
>> +#ifdef CONFIG_PPC32
>> +#define UART_BUG_FSLBK	(1 << 4)	/* buggy FSL break IRQ storm */
>> +#else	/* help GCC optimize away IRQ handler errata code for ARCH != PPC32 */
>> +#define UART_BUG_FSLBK	0
>> +#endif
> 
> I believe this bug still exists on our 64-bit chips.

OK, I'll simply change the above to CONFIG_PPC then.

Thanks,
Paul.

> 
> -Scott
> 
