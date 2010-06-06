Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0FFXr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 19:47:57 -0400
Received: from void.printf.net ([89.145.121.20]:55099 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab0FFXr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 19:47:56 -0400
X-Greylist: delayed 1482 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jun 2010 19:47:56 EDT
Date: Mon, 7 Jun 2010 00:23:13 +0100
From: Chris Ball <cjb@laptop.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc: fix mmc card disappearence on resume on ricoh
	mmc controllers
Message-ID: <20100606232313.GA5444@void.printf.net>
References: <1275859475.3151.4.camel@maxim-laptop> <1275859731-2898-2-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275859731-2898-2-git-send-email-maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 07, 2010 at 12:28:51AM +0300, Maxim Levitsky wrote:
> +	/* Some controllers (especialy the ricoh mmc controller) delay
> +		card detection on resume (probably since the controller
> +		has to poke the card to determine if its MMC or not */
> +
> +	if (host->mmc->bus_ops && (host->quirks &
> +			SDHCI_QUIRK_WAIT_CARD_ON_RESUME)) {
> +
> +		unsigned long timeout = jiffies + msecs_to_jiffies(2000);
> +
> +		while (!time_after(jiffies, timeout))
> +			if (sdhci_readl(host, SDHCI_PRESENT_STATE)
> +							& SDHCI_CARD_PRESENT) {
> +				break;

It looks like your editor is set to four-space instead of eight-space
tab characters, else you wouldn't be using so many tabs here. 

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
