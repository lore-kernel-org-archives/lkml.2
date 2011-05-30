Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab1E3SdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:33:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63083 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab1E3SdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:33:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] sdhci: fix undue iomem warning
Date: Mon, 30 May 2011 20:33:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1306758796-4254-1-git-send-email-daniel.blueman@gmail.com> <BANLkTinL3ZvaNhYnsRMZQ4zBRLx6_F-O6Q@mail.gmail.com> <20110530182103.GA2674@pengutronix.de>
In-Reply-To: <20110530182103.GA2674@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105302033.12409.arnd@arndb.de>
X-Provags-ID: V02:K0:xoQ+u4N/FdkFwjDVBwejCrrc3w8x1mfHF/eAhZA2l96
 3ZkDDRgyrdzK0jE+VxbvwiqHnXAB6rJPPLJI6Y8J39gONv4NID
 6yoDu1EgvyoWRza/wo2o/DQMWKuHneC2Y2bmWUF/i1766HCdCU
 CimLRKMylVTJKIZl75H2IHF8vuPZ35Gj47J/7rJMdiklE4caQe
 2Yn7zsBnU3DgCCVXj5k5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 May 2011 20:21:03 Wolfram Sang wrote:
>   Show Details
>   > > a) SDHC Specs (even v3) only mention 0x100, so this is the standard.
> > >   Do the new cards (which ones?) have anything located in the extra
> > >   area?
> > 
> > This controller is a dual-slot one, so has two register sets (though
> > one set of pins aren't wired to a socket).
> 
> There are two controllers and they are packed into one PCI-bar? :( I guess this
> needs refactoring of the probe_slot routine then. Just silencing the warning
> will just hide the problem.

Right. Presumably someone has already built a different system with the
same chip and both slots in use. This probably also means we need a
way to figure out which of the slots are in fact connected.

> > > b) your approach won't scale very well
> > 
> > True - a more scalable test would be to check for non-zero length and
> > a multiple of 256 bytes, would you say?
> 
> That wouldn't alarm for 0x10000 or the like, so no gain as well.

In fact, all PCI resources are by definition power-of-two numbers,
so the check would not work at all.

> > >> +             dev_warn(&pdev->dev, "Invalid iomem size. You may "
> > >>                       "experience problems.\n");
> > >
> > > I second turning the message into a warning, though.
> > 
> > If the latter method is preferred, I'll adjust the patch and resend.
> 
> Reconsidering: Given the current situation, an error message is maybe not a
> that bad idea, until the code can handle two controllers in one bar.

Agreed.

	Arnd
