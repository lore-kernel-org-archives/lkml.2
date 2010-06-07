Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0FGAdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 20:33:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36521 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab0FGAdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 20:33:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=csYEcRvRxSzPFTmWKUkd9ATSRt4Py89rFL+Vyzm/LM0Vqm/gWKMZCwfg+XuCub2g8n
         Ro2Wnb7QPb0KPyqznzhCADgbgxdVeIPVtZuVqDF+sdo8pbBs2uwItv9evJafddz/25G5
         PAZF3JTptfiKXaN/TnXL6Wd1xiDVbQDGTXH1M=
Subject: Re: [PATCH 2/2] mmc: fix mmc card disappearence on resume on ricoh
 mmc controllers
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100606232313.GA5444@void.printf.net>
References: <1275859475.3151.4.camel@maxim-laptop>
	 <1275859731-2898-2-git-send-email-maximlevitsky@gmail.com>
	 <20100606232313.GA5444@void.printf.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 03:33:15 +0300
Message-ID: <1275870795.24091.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 00:23 +0100, Chris Ball wrote: 
> Hi,
> 
> On Mon, Jun 07, 2010 at 12:28:51AM +0300, Maxim Levitsky wrote:
> > +	/* Some controllers (especialy the ricoh mmc controller) delay
> > +		card detection on resume (probably since the controller
> > +		has to poke the card to determine if its MMC or not */
> > +
> > +	if (host->mmc->bus_ops && (host->quirks &
> > +			SDHCI_QUIRK_WAIT_CARD_ON_RESUME)) {
> > +
> > +		unsigned long timeout = jiffies + msecs_to_jiffies(2000);
> > +
> > +		while (!time_after(jiffies, timeout))
> > +			if (sdhci_readl(host, SDHCI_PRESENT_STATE)
> > +							& SDHCI_CARD_PRESENT) {
> > +				break;
> 
> It looks like your editor is set to four-space instead of eight-space
> tab characters, else you wouldn't be using so many tabs here. 
Nope, I think indention is right here.

the break is inside 'if' condition.

Best regards
Maxim Levitsky

