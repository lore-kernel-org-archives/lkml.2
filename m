Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2KEWmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:42:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab2KEWml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:42:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2] ARM: plat-versatile: move FPGA irq driver to drivers/irqchip
Date: Mon, 5 Nov 2012 22:42:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1351805329-19576-1-git-send-email-linus.walleij@linaro.org> <20121102121556.GV21164@n2100.arm.linux.org.uk> <50983422.9090301@gmail.com>
In-Reply-To: <50983422.9090301@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211052242.26894.arnd@arndb.de>
X-Provags-ID: V02:K0:nvQy/ZTq+d2cdEH5TXQHFUElURBF+4r1NQgHpSrNRdw
 v89n+6cR+Z1OvMgAPuo4R00Jc7DtSquc4oN4rJxNUiSQumP6FJ
 vG57l0KTEjwvZQHUrwyYqOw7BRHGtNhOllcmAdUqmdHYfFY2Yi
 uYRX5Epz6S8PlSxqefTBMTDku2GzsvQjRZVLGPBdENUHu8h5iH
 wZIU5bMghug0K/HIHaGDTn7n5oewIyvlW4xF+6B6cSIxmrUq3q
 IJiqu7SZp/7PY38XuneNVTQTtWTaLCfd+9GMFTEfmizsedhTEE
 r3ESkN0wEsWw13s+C/Y/abEYDNF5zs0+Smb4BGyAzbowZHQLvn
 DRCSyfacP1rNnvOum6EY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 November 2012, Rob Herring wrote:
> But this should work:
> 
> if (!handle_arch_irq)
>         handle_arch_irq = fpga_handle_irq;
> 
> As long as the primary controller is always initialized first, this will
> work. This is guaranteed by DT of_irq_init, and you will probably have
> other problems if that wasn't the case for non-DT.

How about adding a top-level function in arch/arm that does the assignment
and hides the handle_arch_irq variable:

void set_handle_irq(void (*handle_irq)(struct pt_regs *))
{
	if (WARN_ON(handle_arch_irq))
		return;

	handle_arch_irq = handle_irq;
}
EXPORT_SYMBOL_GPL(set_handle_irq);

Hmm, maybe putting the top-level handler into a loadable module is a bit
far-fetched, but one can hope ;-)

	Arnd
