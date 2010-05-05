Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0EEFwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:52:16 -0400
Received: from smtp.nokia.com ([192.100.105.134]:30290 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0EEFwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:52:15 -0400
Subject: Re: [PATCH] sst25l.c: fix multi-part messages with broken spi
 masters
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
       "andre@bluewatersys.com" <andre@bluewatersys.com>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <0D753D10438DA54287A00B0270842697636E305D4A@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636E305D4A@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 08:45:49 +0300
Message-ID: <1273038349.3702.54.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 May 2010 05:52:01.0520 (UTC) FILETIME=[150F2F00:01CAEC17]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 13:34 -0500, H Hartley Sweeten wrote:
> Some SPI masters (ep93xx) have limitations when using the SFRMOUT
> signal for the spi device chip select.  The SFRMOUT signal is
> only asserted as long as the spi transmit fifo contains data.  As
> soon as the last bit is clocked into the receive fifo it gets
> deasserted.
> 
> The functions sst25l_status and sst25l_match_device use the API
> function spi_write_then_read to write a command to the flash then
> read the response back.  This API function creates a two part spi
> message for the write then read.  When this message is transferred
> the SFRMOUT signal ends up getting deasserted after the command
> phase.  This causes the command to get aborted by the device so
> the read phase returns invalid data.
> 
> By changing sst25l_status and sst25l_match_device to use a single
> transfer synchronous message, the SFRMOUT signal stays asserted
> during the entire message so the correct data always gets returned.
> 
> This change will have no effect on SPI masters which use a chip
> select mechanism (GPIO's, etc.) which does stay asserted correctly.
> As a bonus, the single transfer synchronous messages complete faster
> than multi-part messages.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>
> Cc: Andre Renaud <andre@bluewatersys.com>
> Cc: Ryan Mallon <ryan@bluewatersys.com>

Pushed to l2-mtd-2.6 / dunno.

But please, notice for future:
1. It is much nicer to put something like [PATCH v2] when you re-send.
2. In MTD we prefix everything with mtd:

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

