Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1LBWeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 17:34:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39885 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab1LBWeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 17:34:08 -0500
Date: Sat, 3 Dec 2011 02:34:02 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Dave Martin <dave.martin@linaro.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111202223402.GA7780@oksana.dev.rtsoft.ru>
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
 <20111110152606.GB3207@oksana.dev.rtsoft.ru>
 <20111110153816.239af1d7@lxorguk.ukuu.org.uk>
 <20111110162859.GA7088@oksana.dev.rtsoft.ru>
 <20111202191917.GB3037@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111202191917.GB3037@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 07:19:17PM +0000, Dave Martin wrote:
[...]
> > > > Drivers should not use NO_IRQ; moreover, some architectures don't
> > > > have it nowadays. '0' is the 'no irq' case.
> > > > 
> > > > Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> > > 
> > > Acked-by: Alan Cox <alan@linux.intel.com>
> > 
> > In case if we don't want a "band-aid fix" for 3.2, here is the patch
> > that just does the proper fix (w/ a risk to break minor architectures).
> 
> This is now broken on ARM where, for good or bad, NO_IRQ currently is
> used and is -1.
> 
> How do we resolve it?

One option is to test this patch on a board that is now broken:

http://lkml.org/lkml/2011/11/10/290

So that someone provide Tested-by tag. With the tag we probably can
push the patch for 3.2, and thus fix the issue once and forever.


The other option is to revert the correct fix, and push the bogus
one, i.e. this:

http://lkml.org/lkml/2011/11/10/287

But that last option is less likely, as this was NAKed by Alan Cox.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
