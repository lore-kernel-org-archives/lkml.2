Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1F3PPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:15:49 -0400
Received: from ns.penguin.cz ([84.21.108.25]:38042 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab1F3PPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:15:46 -0400
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jun 2011 11:15:46 EDT
Subject: Re: kernel panic in spi_complete() on spitz (PXA270)
From: Stanislav Brabec <utx@penguin.cz>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, zaurus-devel@www.linuxtogo.org,
        spi-devel-general@lists.sourceforge.net,
        Igor Grinberg <grinberg@compulab.co.il>, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com
In-Reply-To: <201106301352.21684.marek.vasut@gmail.com>
References: <1308845380.4533.54.camel@oct.suse.cz>
	 <201106301352.21684.marek.vasut@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 16:45:18 +0200
Message-ID: <1309445118.4406.47.camel@oct.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Vasut wrote:
> On Thursday, June 23, 2011 06:09:40 PM Stanislav Brabec wrote:
> > Hallo.
> > 
> > These Oops and kernel panic were observed on a Zaurus (spitz) machine
> > (ARMv5, PXA270).
> 
> Looks similar to "Re: [PATCH v2] Input: Make ADS7846 independent on regulator"

I don't see any trace in that thread. But yes, I was testing your patch
from this thread. Without it, ADS7846 does not work on spitz (ADS7846
does not have any dedicated regulator there). I want to
add .needs_regulator bool to ads7846.c and send the patch again to the
list.

After sending the trace I was able to reproduced it several times by
attaching of external charger.

Then I tried to apply "[PATCH] MAX1111: Fix race condition causing NULL
pointer exception", connected charger that periodically disconnects and
not seen the crash again. No OOPS was seen after ~100 reconnects.

So I guess that MAX1111 AC voltage reading (via SPI) was involved in an
incorrect moment and race happened there and your MAX1111 race condition
fix fixes it.

-- 
Stanislav Brabec
http://www.penguin.cz/~utx

