Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab0IPHzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:55:18 -0400
Received: from relay.atmel.no ([194.19.124.36]:35040 "EHLO relay.atmel.no"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752266Ab0IPHzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:55:16 -0400
Date: Thu, 16 Sep 2010 09:55:00 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Reduce fOD to 200 kHz if possible
Message-ID: <20100916095500.7e79fc0f@hskinnemoen-d830>
In-Reply-To: <20100915135719.GA1677@void.printf.net>
References: <1284541140-7328-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20100915135719.GA1677@void.printf.net>
Organization: Atmel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Ball <cjb@laptop.org> wrote:
> Hi Haavard,
> 
> On Wed, Sep 15, 2010 at 10:59:00AM +0200, Haavard Skinnemoen wrote:
> > Since the identification frequency was increased to 400 kHz, my
> > ATSTK1000 board has not been able to initialize any MMC or SD cards.
> > Reducing the identification mode frequency to 200 kHz fixes the problem.
> 
> Good news -- there's already a patch to fix this in -mm.
> 
> Please test http://article.gmane.org/gmane.linux.kernel.commits.mm/62969
> and let us know whether it works for you.

It does, sort of. I get this:

atmel_mci atmel_mci.0: Atmel MCI controller at 0xfff02400 irq 28, 1 slots
mmc0: mmc_rescan: trying to init card at 400000 Hz
Freeing init memory: 916K (90000000 - 900e5000)
mmc0: mmc_rescan: trying to init card at 300000 Hz
mmc0: mmc_rescan: trying to init card at 200000 Hz
mmc0: mmc_rescan: trying to init card at 136719 Hz
mmc0: host does not support reading read-only switch. assuming write-enable.
mmc0: new SD card at address 1234
mmcblk0: mmc0:1234 SD1GB 972 MiB 
 mmcblk0: p1

which is mostly ok, since it does succeed at initializing the card
eventually, but it is somewhat surprising that it needs to go all the
way down to 136 kHz. Usually, it works fine at 200 kHz.

On the other hand, I did try something else before testing the 200 kHz
patch: I enabled the internal pull-ups on the MMC lines. Turning them
off again makes the card initialization fail at 200 kHz.

So please ignore my patch, and let's go for Hein's patch instead.

Haavard
