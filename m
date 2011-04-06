Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1DFMu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:50:57 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:39917 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab1DFMu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:50:56 -0400
Date: Wed, 6 Apr 2011 14:50:54 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Hellstrom <thomas@shipmail.org>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 .. [GIT
 PULL] stable/ttm.pci-api-rc2 for 2.6.39-rc2
Message-ID: <20110406125054.GB1634@x4.trippels.de>
References: <20110329145651.GA1641@gentoo.trippels.de>
 <20110405163141.GA1651@x4.trippels.de>
 <20110406085407.GA1634@x4.trippels.de>
 <4D9C2ED7.9010906@shipmail.org>
 <20110406122715.GB5009@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406122715.GB5009@dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.04.06 at 08:27 -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Apr 06, 2011 at 11:13:59AM +0200, Thomas Hellstrom wrote:
> > Dave, Konrad
> > 
> > I think we need to back out this change as soon as possible. I will
> > follow up the discussion with Konrad on how we should attempt to
> > handle vm passthrough as soon as things settle down a bit over here.
> 
> Ok. I believe just reverting this particular git commit
> 
> 69a07f0b117a40fcc1a479358d8e1f41793617f2
> 
> does it. Doing it on top of v2.6.39-rc1:
> 
> ated: 2427 deleted: 1229), skipping inexact rename detection
> Finished one revert.
> [stable/ttm.pci-api-rc2 97bbc38] Revert "ttm: Utilize the DMA API for pages that have TTM_PAGE_FLAG_DMA32 set."
>  1 files changed, 3 insertions(+), 23 deletions(-)
> 
> shows it to being a nice easy backout.
> 
> Dave, I stuck the revert on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/ttm.pci-api-rc2
> 
> Please pull for rc2.

> .. snip..
> > >Looks like this is caused by f9820a46dd7888b05a36e81166fb1abcc47dcc3f :
> 
> Wrong git commit.
> 
> > >
> > >  ttm: Utilize the DMA API for pages that have TTM_PAGE_FLAG_DMA32 set.
> 
> It is 69a07f0b117a40fcc1a479358d8e1f41793617f2

Oops, you're right. (copy&paste error)

> > >CCing the relevant people.
> 
> How did you make the machine to do this? Did you just echo XX > to the shrinker?

No, I've just used the machine normally (browsing the net, viewing pdfs,
etc.) and triggered the warning two times in the last couple of days.

-- 
Markus
