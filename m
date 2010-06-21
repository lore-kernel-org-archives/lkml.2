Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0FUTkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:40:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757566Ab0FUTkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:40:01 -0400
Date: Mon, 21 Jun 2010 12:39:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] Two fixes for my mmc/sd cardreader
Message-Id: <20100621123921.045e245f.akpm@linux-foundation.org>
In-Reply-To: <1277148104.4241.1.camel@maxim-laptop>
References: <1276809695.28201.13.camel@maxim-laptop>
	<1277148104.4241.1.camel@maxim-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 22:21:44 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Fri, 2010-06-18 at 00:21 +0300, Maxim Levitsky wrote: 
> > Hi,
> > 
> > These are 2 fixes for my card reader.
> > 
> > 
> > First patch fixes old issue with system hand on suspend to disk/ram with
> > mmc card inserted.
> > I updated description, and pm notification registration order.
> > I think this patch can an should go to 2.6.35, because it fixes long
> > standing and nasty regression.
> > 
> > The second patch is a result of my work trying to understand why my card
> > reader sometimes dies on resume.
> > This reader has a special MMC function which steals MMC cards, and until
> > now had no driver. A way to disable it was found, and while it works, it
> > has (at least here) a side effect of killing the controller on resume
> > from ram/disk (and it happens often, and doesn't depend of whether card
> > was in slot or not during suspend).
> > 
> > Fortunately it turned out that MMC part is _almost_ standard SDHCI
> > controller.
> > This patch adds support for this device to standard sdhci driver.
> > Unfortunately, this support still contais small hack.
> > It waits 1/2 of a second on resume before initializing the controller.
> > Not doing so, and resuming with MMC card present results in confused
> > controller. It is not dead though. A card reinsert makes it work again
> > with all cards.
> > Yet the 1st patch is must for this because otherwise mmc core seeing
> > that controller doesn't respond, removes the card, therefore hangs the
> > system.
> > It doesn't happen when I wait these 1/2 of second though.
> > 
> > I think that this patch is also ok for 2.6.35, because it only adds new
> > functionality.
> > You are free to disable MMC controller using the same
> > CONFIG_MMC_RICOH_MMC.
> > 
> > If you don't disable it though, instead of full lack of functionality
> > you will get full featured MMC controller.
> > 
> > Best regards,
> > Maxim Levitsky
> > 
> > 
> > 
> ping

hey, that was only three days.  I commonly leave things to bake on the
mailing list for a while, see what people have to say about it. 
Particularly with subsystems like MMC.
