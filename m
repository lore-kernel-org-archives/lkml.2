Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab0IHWGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:06:12 -0400
Received: from void.printf.net ([89.145.121.20]:50388 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113Ab0IHWGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:06:06 -0400
Date: Wed, 8 Sep 2010 23:05:48 +0100
From: Chris Ball <cjb@laptop.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/8] sdhci: Move real work out of an atomic context
Message-ID: <20100908220548.GA7967@void.printf.net>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru> <20100907153813.936db0c6.akpm@linux-foundation.org> <20100908213740.GA7550@void.printf.net> <20100908215750.GA17232@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908215750.GA17232@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Thu, Sep 09, 2010 at 01:57:50AM +0400, Anton Vorontsov wrote:
> Thanks!
> 
> Would be also great if you could point out which patch causes
> most of the performance drop (if any)?
> 
> Albert, if you could find time, can you also "bisect" the
> patchset? I wouldn't want to buy Nintendo WII just to debug the
> perf regression. ;-) FWIW, I tried to disable multiblock
> read/writes and test with SD cards, and still didn't notice
> any performance drops.
> 
> Maybe it's SDIO IRQs that cause the performance drop for the
> WII case, as we delay them a little bit? Or it could be the
> patch that introduces threaded IRQ handler in whole causes
> it. If so, I guess we'd need to move some of the processing to
> the real IRQ context, keeping the handler lockless (if
> possible) or introducing a very fine grained locking.

I didn't know anything about a reported performance drop, and I don't
think Andrew did either -- Albert's test results don't seem to have
made it to this list, or anywhere else that I can see.  Could you 
link to/repost his comments?

(I'll be testing with libertas, so that will stress-test SDIO IRQs.)

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
