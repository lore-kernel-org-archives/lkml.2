Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1LAXvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:51:12 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:6830 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab1LAXvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:51:10 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzbb2dK9371K98dKzz1202hzzz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4ED812E4.60905@freescale.com>
Date: Thu, 1 Dec 2011 17:51:00 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <gregkh@suse.de>, <alan@linux.intel.com>, <galak@kernel.crashing.org>,
        <linux-serial@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] 8250: add workaround for MPC8[356]xx UART break IRQ
 storm
References: <1322783258-20443-1-git-send-email-paul.gortmaker@windriver.com> <1322783258-20443-4-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1322783258-20443-4-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 05:47 PM, Paul Gortmaker wrote:
> diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
> index 8c660af..b0f4042 100644
> --- a/include/linux/serial_8250.h
> +++ b/include/linux/serial_8250.h
> @@ -18,6 +18,11 @@
>  #define UART_BUG_TXEN	(1 << 1)	/* buggy TX IIR status */
>  #define UART_BUG_NOMSR	(1 << 2)	/* buggy MSR status bits (Au1x00) */
>  #define UART_BUG_THRE	(1 << 3)	/* buggy THRE reassertion */
> +#ifdef CONFIG_PPC32
> +#define UART_BUG_FSLBK	(1 << 4)	/* buggy FSL break IRQ storm */
> +#else	/* help GCC optimize away IRQ handler errata code for ARCH != PPC32 */
> +#define UART_BUG_FSLBK	0
> +#endif

I believe this bug still exists on our 64-bit chips.

-Scott

