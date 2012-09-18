Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab2IRIcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:32:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab2IRIct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:32:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 19/24] sh: use __iomem pointers for MMIO
Date: Tue, 18 Sep 2012 08:01:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-sh@vger.kernel.org
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-20-git-send-email-arnd@arndb.de> <20120918073741.GN13568@linux-sh.org>
In-Reply-To: <20120918073741.GN13568@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209180801.48038.arnd@arndb.de>
X-Provags-ID: V02:K0:64qD/ePrE0KprDmHo5xx79k+XnMdjttS5MsdJ+BkFKP
 s3VErimzVHy7gy7I9JKvvSzM4tua0CBRw+xGPxQj7gIB5U+DIi
 hNCdu+KIhz9soxBPR+uFmaubMA8HUzk+gyS/nNr353T17J9jKC
 nNSXlfZ9aanjzandDxANo4Vstuh8feyabjFRd78YSokKIfIHVa
 err7z6vvMSkoN1M/euiJZmV3ZNiGhwyZ8I7N/oSu50MTrKyuqa
 EugXtCc+RIvS/rREAI6aOhNJX/RSpEIBYLSbbTiCzBuQoNuLFm
 vgTovdEFdF/tLgjxBo95cIFDJyHwQoZqTsabWS2v1v4EPtbJwP
 /BmbDFAQ8re4gJDam/Hs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2012, Paul Mundt wrote:
> On Fri, Sep 14, 2012 at 11:34:47PM +0200, Arnd Bergmann wrote:
> > ARM is moving to stricter checks on readl/write functions,
> > so we need to use the correct types everywhere.
> > 
> > I'm not completely sure about this patch, and it will
> > probably require some arch/sh changes to go along with it,
> > but it's clear that something has to be done to avoid
> > getting hundreds of new warnings on each shmobile build
> > in v3.7.
> > Please see this as a prototype.
> > 
> I have no intention of making this change for arch/sh.
> 
> The __raw variants already accept both __iomem pointers and integer
> addresses, which was largely intentional. New code could use the __iomem
> annotations while older code could continue to use the integer addresses
> without issue.

Ok, I'm dropping this patch from the series then.

> If you wish to go through the kernel and audit every
> single __raw user, you're certainly welcome to, but until then such a
> change is premature.

I've done it for all the defconfig files for now, which probably covers
most of the drivers that are relevant on ARM. I still have a backlog
of unrelated warning fixes from that. Once I'm done with those, I'm planning
to do another round of randconfig builds, which hopefully catches the
rest. I'll just exclude drivers/sh from those builds for now.

	Arnd

