Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1LAJzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:55:24 -0500
Received: from d1.icnet.pl ([212.160.220.21]:39907 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1LAJzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:55:21 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2a/5] Remove unsafe clock values from omap1_defconfig
Date: Thu, 1 Dec 2011 10:54:09 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20111128174508.GO31337@atomide.com> <201112010310.43890.jkrzyszt@tis.icnet.pl> <20111201022750.GY13928@atomide.com>
In-Reply-To: <20111201022750.GY13928@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011054.09878.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've unintentionally answered off-line, sorry, re-adding all Cc:'s.

On Thursday 01 of December 2011 at 03:27:51, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111130 17:40]:
> > On Wednesday 30 of November 2011 at 23:32:42, Tony Lindgren wrote:
> > >  
> > > Can you please split your series into two: Fix(es) for the -rc cycle,
> > > then patches that can be left for the next merge window.
> > 
> > From my point of view, all 5 are important fixes. Please decide 
> > yourself, having the following information provided:
> > 
> > 1/5: inspired by in-line comments about running from sram requirement
> > 	(works without this one for me),
> > 
> > 2/5: without this one, system clock runs way too fast if dpll1 is 
> > 	reprogrammed to default rate,
> > 
> > 3/5: without this one, all boards with bootloaders not setting rate 
> > 	correctly, like Amstrad Delta, will run at default rate, despite 
> > 	any .config selections, no matter if omap1_defconfig or custom,
> > 
> > 2a/5: required by 3/5,
> > 
> > 5/5: without this one, BogoMIPS is not updated after dpll1 reprogramme, 
> > 	breaking omap_keypad at least.
> > 
> > and please let me know which I should resend as fixes and which not.
> 
> How about 2 and 5 as fixes during the -rc, then the rest for the
> merge window? That is assuming that those are enough for you to have
> things mostly working.

If you still ask me for my opinion: with patch 3/5 omitted, then not 
being able to run at any other frequency than 60 MHz instead of usual 
150 since the board support was introduced first, isn't this a 
regression? Having a choice of upgrading to 3.2 and running my 
application on not very powerfull board at 60 MHz, or keep running 3.1 
at 150, guess what I chose? If I were a distro kernel package 
maintainer, guess what I would chose?

> It seems that we've had the issue of not actually changing the rate
> for a while, right?

This was not an issue before dpll1 reprogramming has been moved out from 
omap1_clk_init(), as an rc fix to another bug introduced in 3.2. Perhaps 
we should rather think of reverting a few commits which caused all these 
problems if fixing them all during rc cycle seems not possible? I 
haven't bisected them yet, rather concentrated on providing fixes, but I 
can still try to do it, starting back from the original issue 
(http://www.spinics.net/lists/linux-omap/msg60052.html), if so decided.

> If that's the case, I'd rather not start messing
> with that during the -rc cycle.
> 
> Regards,
> 
> Tony

I don't feel like a person who makes the final decision.

Anyway, did you mean resending those 2/5 and 5/5 without any changes, 
only renumbered as 1/2 and 2/2?

Thanks,
Janusz
