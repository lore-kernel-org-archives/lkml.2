Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab0FUTVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:21:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49303 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab0FUTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J31h0pFjFwXFmA4lbhytrQCMn7N/LPo8kSgxif93sY5OG9JuRoQuH+jLar8IHnVGK2
         rHgiGbR+e/hYUhBATfsVasoRfcLnPGjIuwU73zMHQ0+KdkraQoup1N5FGOdCH/tWME1z
         HU4fWCDiNNwHI7QKy41QJvuDsymU7MG+qudLM=
Subject: Re: [PATCH] Two fixes for my mmc/sd cardreader
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-mmc <linux-mmc@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>
In-Reply-To: <1276809695.28201.13.camel@maxim-laptop>
References: <1276809695.28201.13.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 22:21:44 +0300
Message-ID: <1277148104.4241.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 00:21 +0300, Maxim Levitsky wrote: 
> Hi,
> 
> These are 2 fixes for my card reader.
> 
> 
> First patch fixes old issue with system hand on suspend to disk/ram with
> mmc card inserted.
> I updated description, and pm notification registration order.
> I think this patch can an should go to 2.6.35, because it fixes long
> standing and nasty regression.
> 
> The second patch is a result of my work trying to understand why my card
> reader sometimes dies on resume.
> This reader has a special MMC function which steals MMC cards, and until
> now had no driver. A way to disable it was found, and while it works, it
> has (at least here) a side effect of killing the controller on resume
> from ram/disk (and it happens often, and doesn't depend of whether card
> was in slot or not during suspend).
> 
> Fortunately it turned out that MMC part is _almost_ standard SDHCI
> controller.
> This patch adds support for this device to standard sdhci driver.
> Unfortunately, this support still contais small hack.
> It waits 1/2 of a second on resume before initializing the controller.
> Not doing so, and resuming with MMC card present results in confused
> controller. It is not dead though. A card reinsert makes it work again
> with all cards.
> Yet the 1st patch is must for this because otherwise mmc core seeing
> that controller doesn't respond, removes the card, therefore hangs the
> system.
> It doesn't happen when I wait these 1/2 of second though.
> 
> I think that this patch is also ok for 2.6.35, because it only adds new
> functionality.
> You are free to disable MMC controller using the same
> CONFIG_MMC_RICOH_MMC.
> 
> If you don't disable it though, instead of full lack of functionality
> you will get full featured MMC controller.
> 
> Best regards,
> Maxim Levitsky
> 
> 
> 
ping

