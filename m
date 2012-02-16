Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab2BPORN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:17:13 -0500
Received: from skyrme.org ([193.175.80.135]:46555 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab2BPORL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:17:11 -0500
Date: 16 Feb 2012 14:17:07 +0000
Message-ID: <20120216141707.GA8647@curry>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Wolfram Sang" <w.sang@pengutronix.de>
Cc: "Oskar Schirmer" <oskar@scara.com>, wim@iguana.be, s.hauer@pengutronix.de,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: make imx2_wdt report boot status correctly
References: <1329394665-7238-1-git-send-email-oskar@scara.com> <20120216133510.GA2541@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216133510.GA2541@pengutronix.de>
User-Agent: Mutt/1.4.2.3i
Organisation: www.embedded-group.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thu, Feb 16, 2012 at 14:35:10 +0100, Wolfram Sang wrote:
> besides this minor thing (which may be just personal taste)...
> 
> > +	case WDIOC_GETBOOTSTATUS:
> > +		val = __raw_readw(imx2_wdt.base + IMX2_WDT_WRSR);
> > +		new_value = 0;
> > +		if (val & IMX2_WDT_WRSR_TOUT)
> > +			new_value = WDIOF_CARDRESET;
> 
> I'd go for this to save some lines:
> 		new_value = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;

A good alternative for sure.

Seen from the perspective of code compactness ("save some lines"),
one could try to be consequent here, and save the "val" variable
altogether, ending up with some "new_value = __raw_readw ... & ... ? ... : 0;"
But eventually there might be code readability issues, so it's
a good idea to keep the balance.

An argument for the original, longer version might be it is easier
to extend, when more flags need to be handled, like
"else if (val & ...) new_value = ...", while nested conditional
expressions would most likely become quite complex soon.

Actually, my personal taste doesn't show a preference for
one version or the other, so I'm ok with Your proposal, too.

  Oskar
