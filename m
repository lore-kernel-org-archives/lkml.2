Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0IHV6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:58:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52909 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0IHV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:57:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i/fmx3VeyUCTA1AclFPU5yQCnDmtMcFVMbXwdwMgk1E99hbbVbhlJHTu6jlsA/1Opg
         vsvfpxMFwVKeYQjFFL2AW97ZJto6qgCzo9dNXtQj30rmY7Gv3KqmBULCgtd8pSEO3x6Z
         GT84WmDLyvuqXFh9LGOtp/wcrgCj9aHkJNq68=
Date: Thu, 9 Sep 2010 01:57:50 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/8] sdhci: Move real work out of an atomic context
Message-ID: <20100908215750.GA17232@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
 <20100907153813.936db0c6.akpm@linux-foundation.org>
 <20100908213740.GA7550@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100908213740.GA7550@void.printf.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 10:37:41PM +0100, Chris Ball wrote:
> Hi Andrew,
> 
> On Tue, Sep 07, 2010 at 03:38:13PM -0700, Andrew Morton wrote:
> > > I noticed no throughput drop neither with PIO transfers nor
> > > with DMA (tested on MPC8569E CPU), while latencies should be
> > > greatly improved.
> > 
> > This patchset isn't causing any problems yet, but may do so in the
> > future and will impact the validity of any testing.  It seems to be
> > kind of stuck.  Should I drop it all?
> 
> I suggest keeping it -- I'll find time to test it out here soon, and
> will keep it in mind as a possible regression cause.

Thanks!

Would be also great if you could point out which patch causes
most of the performance drop (if any)?

Albert, if you could find time, can you also "bisect" the
patchset? I wouldn't want to buy Nintendo WII just to debug the
perf regression. ;-) FWIW, I tried to disable multiblock
read/writes and test with SD cards, and still didn't notice
any performance drops.

Maybe it's SDIO IRQs that cause the performance drop for the
WII case, as we delay them a little bit? Or it could be the
patch that introduces threaded IRQ handler in whole causes
it. If so, I guess we'd need to move some of the processing to
the real IRQ context, keeping the handler lockless (if
possible) or introducing a very fine grained locking.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
