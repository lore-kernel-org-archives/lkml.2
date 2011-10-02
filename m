Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab1JBQPO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 12:15:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56442 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1JBQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 12:15:04 -0400
Date: Sun, 2 Oct 2011 17:14:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 15/30] usb/musb: use a Kconfig choice to pick the right
	DMA method
Message-ID: <20111002161447.GC12323@n2100.arm.linux.org.uk>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-16-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317566760-25681-16-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 04:45:45PM +0200, Arnd Bergmann wrote:
> The logic to allow only one DMA driver in MUSB is currently
> flawed, because it also allows picking no DMA driver at all
> and also not selecting PIO mode.
> 
> Using a choice statement makes this foolproof for now and
> also simplifies the Makefile.
> 
> Unfortunately, we will have to revisit this when we start
> supporting multiple ARM platforms in a single kernel binary,
> because at that point we will actually need to select
> multiple DMA drivers and pick the right one at run-time.

I thought there was some work going on to convert this to use the
dmaengine stuff?

But in any case, a stop-gap fix is needed for randconfig.
