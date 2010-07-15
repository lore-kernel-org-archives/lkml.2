Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab0GOGC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 02:02:59 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60299 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932499Ab0GOGC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 02:02:57 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Ben Dooks <ben-linux@fluff.org>, Pierre Ossman <pierre@ossman.eu>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/8] sdhci: Move real work out of an atomic context
In-Reply-To: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
User-Agent: Notmuch/0.3.1-61-g3f63bb6 (http://notmuchmail.org) Emacs/23.1.90.2 (x86_64-unknown-linux-gnu)
Date: Thu, 15 Jul 2010 07:02:55 +0100
Message-ID: <87oce9z3hs.fsf@linux-g6p1.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 17:07:28 +0400, Anton Vorontsov <avorontsov@mvista.com> wrote:
> Hi all,
> 
> Currently the sdhci driver does everything in the atomic context.
> And what is worse, PIO transfers are made from the IRQ handler.
> 
> This causes huge latencies (up to 120 ms). On some P2020 SOCs,
> DMA and card detection is broken, which means that kernel polls
> for the card via PIO transfers every second. Needless to say
> that this is quite bad.
> 
> So, this patch set reworks sdhci code to avoid atomic context,
> almost completely. We only do two device memory operations
> in the atomic context, and all the rest is threaded.
> 
> I noticed no throughput drop neither with PIO transfers nor
> with DMA (tested on MPC8569E CPU), while latencies should be
> greatly improved.

I haven't had time to read these patches in detail yet but they all seem
to be sensible changes. A very nice series!
