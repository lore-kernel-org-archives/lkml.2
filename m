Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1F3PhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:37:21 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38070 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1F3PhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:37:19 -0400
From: Pavel Herrmann <morpheus.ibis@gmail.com>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
        zaurus-devel@www.linuxtogo.org,
        spi-devel-general@lists.sourceforge.net,
        Igor Grinberg <grinberg@compulab.co.il>, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com
Subject: Re: kernel panic in spi_complete() on spitz (PXA270)
Date: Thu, 30 Jun 2011 17:36:57 +0200
Message-ID: <22208110.jIqhYvKY9h@bloomfield>
User-Agent: KMail/4.6.0 (Linux/2.6.33-gentoo-r1; KDE/4.6.4; x86_64; ; )
In-Reply-To: <201106301709.48818.marek.vasut@gmail.com>
References: <1308845380.4533.54.camel@oct.suse.cz> <1309445118.4406.47.camel@oct.suse.cz> <201106301709.48818.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 30, 2011 04:45:18 PM Stanislav Brabec wrote:
> Then I tried to apply "[PATCH] MAX1111: Fix race condition causing NULL
> pointer exception", connected charger that periodically disconnects and
> not seen the crash again. No OOPS was seen after ~100 reconnects.
> 
> So I guess that MAX1111 AC voltage reading (via SPI) was involved in an
> incorrect moment and race happened there and your MAX1111 race condition
> fix fixes it.

Hi,

Are you using the first or second version of the patch? if the former, please 
use v2 (sent a few days later), which has solved the same problem by using a 
mutex instead of allocating message data on stack (which is not good for DMA)

as for the backstory, this crash ocurrs when a short (measured in time spent) 
message was enqueued after a long message, so that the short one finished first 
(the actual bug was present even if the long one finished first, but in that 
case there was double complete() on the one completion instead of a NULL 
dereference)

Pavel
