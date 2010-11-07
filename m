Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0KGRQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 12:16:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47290 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0KGRQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 12:16:16 -0500
Date: Sun, 7 Nov 2010 17:15:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Ulf Hansson <ulf.hansson@stericsson.com>
Subject: Re: [PATCH] mmci: reset voltage after power off.
Message-ID: <20101107171559.GE1759@n2100.arm.linux.org.uk>
References: <1288949741-9712-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288949741-9712-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 10:35:41AM +0100, Linus Walleij wrote:
> From: Ulf Hansson <ulf.hansson@stericsson.com>
> 
> At power off, reset OCR mask to be the highest possible voltage
> supported for the current mmc host.
> 
> This solves the re-initialization during the power up sequence.
> The voltage may have been decreased due to the card accepts a lower
> voltage than the voltage used during the initialization sequence.
> We need to reset the voltage to by the host highest possible value
> since according to specification the initialization must always be
> done at high voltage.

Surely this should already be done by:

        /* If ocr is set, we use it */
        if (host->ocr)
                bit = ffs(host->ocr) - 1;
        else
                bit = fls(host->ocr_avail) - 1;

in mmc_power_up ?
