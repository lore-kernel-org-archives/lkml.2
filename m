Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0LHXfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:35:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:57927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LHXfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:35:14 -0500
Subject: Re: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
From: David Woodhouse <dwmw2@infradead.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentin.chary@gmail.com>, sedat.dilek@gmail.com,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 08 Dec 2010 23:35:08 +0000
In-Reply-To: <20101208233101.GA15294@core.coreip.homeip.net>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
	 <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
	 <1291801990.5992.105.camel@i7.infradead.org>
	 <20101208174603.GA7107@core.coreip.homeip.net>
	 <20101208135105.a8482d46.randy.dunlap@oracle.com>
	 <1291849721.5992.145.camel@i7.infradead.org>
	 <20101208233101.GA15294@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.3 
Content-Transfer-Encoding: 7bit
Message-ID: <1291851309.5992.150.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 15:31 -0800, Dmitry Torokhov wrote:
> Even better tool would allow selecting the needed optios right there,
> without the need of moving away from teh current option.

That's exactly what the Nemesis version of xconfig did, almost 15 years
ago.

>  And yet better tool would not even ask user and enable them on its
> own. Hey, but we have it! It's called "select".

The tools could do that with 'depends on' too. Why make a distinction?

> Seriously, select is dangerous. I wonder if a rule like "One can only
> select a symbol whose dependencies are all satisfied by the current
> symbol and/or its parents and the symbols they select or depend on"
> would not make select safe enough. 

"One can only select a symbol which isn't otherwise presented to the
user as a choice".

So things like CONFIG_REED_SOLOMON are fine to be selected, because the
user would never see it anyway.

Otherwise, just use depends. And if that's a problem for you, fix the
damn tools.
 
-- 
dwmw2

