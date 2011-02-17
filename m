Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1BQRbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:31:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1BQRbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:31:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCHv2 09/11] unicore32 core architecture: timer and time handling
Date: Thu, 17 Feb 2011 18:31:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <02f301cbcb48$bebea4c0$3c3bee40$@mprc.pku.edu.cn>
In-Reply-To: <02f301cbcb48$bebea4c0$3c3bee40$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171831.16713.arnd@arndb.de>
X-Provags-ID: V02:K0:lmSXNaSG3CbC71X/Hw6sUQJ2MQu2drQTTUdjuqspVHV
 lNgxF7zx/AiOUikF3wghHl9wJUn2lsOBZXDPcHFuB2DIj5X59k
 aQ4HHvu1J1v/xn1f3bJ+UdU3+3DBWNAo5iYEs6LHgV/qsZz3sl
 Fij8JIS5gnERRCdhH/P3EGZXYslsPH2uacB6LFFn45WxI0yfbs
 6tVBa0FV8t2jvsOlcNKvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 February 2011, Guan Xuetao wrote:

> diff --git a/arch/unicore32/include/asm/timex.h b/arch/unicore32/include/asm/timex.h
> new file mode 100644
> index 0000000..faf16ba
> --- /dev/null
> +++ b/arch/unicore32/include/asm/timex.h
> +#ifndef __UNICORE_TIMEX_H__
> +#define __UNICORE_TIMEX_H__
> +
> +#ifdef CONFIG_ARCH_FPGA
> +
> +/* in FPGA, APB clock is 33M, and OST clock is 32K, */
> +/* so, 1M is selected for timer interrupt correctly */
> +#define        CLOCK_TICK_RATE         (32*1024)
> +
> +#endif
> +
> +#if defined(CONFIG_PUV3_DB0913)                \
> +       || defined(CONFIG_PUV3_NB0916)  \
> +       || defined(CONFIG_PUV3_SMW0919)
> +
> +#define  CLOCK_TICK_RATE         (14318000)
> +
> +#endif

I believe that we don't use CLOCK_TICK_RATE in the kernel any more,
so there is no reason to define it.

	Arnd
