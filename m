Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab0GUVO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:14:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932Ab0GUVO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:14:57 -0400
Date: Wed, 21 Jul 2010 14:13:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/8] sdhci: Move real work out of an atomic context
Message-Id: <20100721141352.d7993493.akpm@linux-foundation.org>
In-Reply-To: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 17:07:28 +0400
Anton Vorontsov <avorontsov@mvista.com> wrote:

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
> 

The patchset looks good to me, but it'd be nice to hear from the other
people who work on this code, please?

