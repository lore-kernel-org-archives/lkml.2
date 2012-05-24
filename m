Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2EXBMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:12:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50554 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2EXBMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:12:21 -0400
Date: Wed, 23 May 2012 18:12:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -linus] regmap: REMAP_IRQ should select IRQ_DOMAIN
 itself
In-Reply-To: <alpine.DEB.2.00.1205231735100.8785@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1205231810570.28167@chino.kir.corp.google.com>
References: <20120522183037.75ec03c9d8881ec188e7f787@canb.auug.org.au> <4FBBAF1B.1070702@xenotime.net> <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com> <20120523093208.GB4085@opensource.wolfsonmicro.com> <CA+55aFynyjrHUCh48aXSQpZpboQM7MCCtMHvxBxCf+gDoCVWXg@mail.gmail.com>
 <20120523173342.GB4064@opensource.wolfsonmicro.com> <alpine.DEB.2.00.1205231735100.8785@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, David Rientjes wrote:

> So my patch to select IRQ_DOMAIN for REGMAP_IRQ is correct since 
> REGMAP_IRQ now requires IRC_DOMAIN since the commit listed in the 
> changelog.
> 
> What's fragile is going around and adding "select IRQ_DOMAIN" to 
> everything that does "select REGMAP_IRQ".  So I removed that and just made 
> IRQ_DOMAIN select REGMAP_IRQ itself.
> 
> So can this be merged or what's the issue?
> 

Oh well, Linus already merged your git pull that you didn't cc to me and 
you did it with a bogus commit message that insists this is only a 
randconfig issue when in reality you never tested enabling 
CONFIG_MFD_PALMAS without CONFIG_IRQ_DOMAIN when you merged 4af8be67fd99 
("regmap: Convert regmap_irq to use irq_domain").
