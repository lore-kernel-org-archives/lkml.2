Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab1LBASM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:18:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:53527 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab1LBASK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:18:10 -0500
Subject: Re: [PATCH 3/3] 8250: add workaround for MPC8[356]xx UART break IRQ storm
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <4ED81632.3030809@windriver.com>
Date: Thu, 1 Dec 2011 18:17:56 -0600
Cc: Scott Wood <scottwood@freescale.com>, <gregkh@suse.de>,
        <alan@linux.intel.com>, <linux-serial@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <176AE2A1-6AA2-4F14-942F-8ED77AB1DBEC@kernel.crashing.org>
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com> <1322783258-20443-4-git-send-email-paul.gortmaker@windriver.com> <4ED812E4.60905@freescale.com> <4ED81632.3030809@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 1, 2011, at 6:05 PM, Paul Gortmaker wrote:

> On 11-12-01 06:51 PM, Scott Wood wrote:
>> On 12/01/2011 05:47 PM, Paul Gortmaker wrote:
>>> diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
>>> index 8c660af..b0f4042 100644
>>> --- a/include/linux/serial_8250.h
>>> +++ b/include/linux/serial_8250.h
>>> @@ -18,6 +18,11 @@
>>> #define UART_BUG_TXEN	(1 << 1)	/* buggy TX IIR status */
>>> #define UART_BUG_NOMSR	(1 << 2)	/* buggy MSR status bits (Au1x00) */
>>> #define UART_BUG_THRE	(1 << 3)	/* buggy THRE reassertion */
>>> +#ifdef CONFIG_PPC32
>>> +#define UART_BUG_FSLBK	(1 << 4)	/* buggy FSL break IRQ storm */
>>> +#else	/* help GCC optimize away IRQ handler errata code for ARCH != PPC32 */
>>> +#define UART_BUG_FSLBK	0
>>> +#endif
>> 
>> I believe this bug still exists on our 64-bit chips.
> 
> OK, I'll simply change the above to CONFIG_PPC then.

It does, the bug is in the uart IP which I don't think we ever plan on fixing, so 32 or 64-bit parts will have it for ever and ever ;)

- k