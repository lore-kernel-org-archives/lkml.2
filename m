Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab0HTPM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:12:58 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:39981 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752692Ab0HTPM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:12:56 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Aug 2010 11:12:55 EDT
Message-ID: <4C6E9B75.8030004@arndnet.de>
Date: Fri, 20 Aug 2010 17:12:53 +0200
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Yusuke Goda <yusuke.goda.sx@renesas.com>
CC: ian@mnementh.co.uk, damm@opensource.se, sameo@linux.intel.com,
        Paul Mundt <lethal@linux-sh.org>, g.liakhovetski@gmx.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmio_mmc: Make ack_mmc_irqs() write-only
References: <4C455597.2020200@renesas.com>
In-Reply-To: <4C455597.2020200@renesas.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.07.2010 09:51, schrieb Yusuke Goda:
> This patch updates ack_mmc_irqs() to acknowledge using write instead
> of read-modify-write. Without this fix the old read-modify-write
> implementation may acknowledge interrupt sources by mistake. The
> driver may if so lock-up waiting forever for an interrupt that will
> never come. Observed with the TMIO_STAT_RXRDY bit together with
> CMD53 on AR6002 and BCM4318 SDIO cards in polled mode.
>
> Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>

Tested on AP4EVB (sh7372) with SDHC and MMC cards - no regression.

Tested-by: Arnd Hannemann <arnd@arndnet.de>
