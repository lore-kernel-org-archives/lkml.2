Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1LASzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:55:07 -0500
Received: from d1.icnet.pl ([212.160.220.21]:38963 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab1LASzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:55:05 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2a/5 v2] ARM: OMAP1: select clock rate by CPU type
Date: Thu, 1 Dec 2011 19:54:18 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20111128174508.GO31337@atomide.com> <201112011110.11476.jkrzyszt@tis.icnet.pl> <20111201182254.GU31337@atomide.com>
In-Reply-To: <20111201182254.GU31337@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011954.18258.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 of December 2011 at 19:22:54, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111201 01:35]:
> > On Wednesday 30 of November 2011 at 23:28:38, Tony Lindgren wrote:
> > > 
> > > We should also now be able to remove all the CONFIG_OMAP_ARM_XXXMHZ options
> > > too, right?
> > 
> > Right, but then, perhaps the initial version of patch 2a/5, which 
> > already started removing them, from omap1_defconfig for now, then going 
> > into the right direction while unblocking another regression fix (3/5), 
> > _is_ a good candidate for an rc fix?
> 
> But we did not allow dpll1 reprogramming earlier either,

Wrong. Without OMAP_CLOCKS_SET_BY_BOOTLOADER selected, we always did, 
but only once, early at boot, before ck_dpll1_p->rate was set first from 
omap1_clk_init(), and never retried later, that's why that check which I 
removed with 3/5 was never in the game until e9b7086b80c4d9e354f4edc9e280ae85a60df408.

> so we should
> not need to make all these changes during the -rc cycle. I'm suspecting
> that we've had this same behaviour for a really long time, and we just
> have not seen it as omap1_defconfig had OMAP_CLOCKS_SET_BY_BOOTLOADER
> option set.
> 
> So I'm baffled how your board would be booting at a different rate
> compared to v3.1, it seems that the logic has not changed there. Or
> else we have some simple bug somewhere.
> 
> Care to try to verify at what point your system started booting at
> 60MHz rate?

Since e9b7086b80c4d9e354f4edc9e280ae85a60df408, I guess, and it's hard 
to confirm wituout bisecting the issue with too early sram call, back 
until things still worked like before map_io related changes. I will do 
that if you decide we should try to revert.

Thanks,
Janusz
