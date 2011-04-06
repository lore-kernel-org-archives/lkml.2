Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab1DFM2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:28:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22788 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1DFM2D (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 6 Apr 2011 08:28:03 -0400
Date: Wed, 6 Apr 2011 08:27:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>, Dave Airlie <airlied@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 .. [GIT
 PULL] stable/ttm.pci-api-rc2 for 2.6.39-rc2
Message-ID: <20110406122715.GB5009@dumpdata.com>
References: <20110329145651.GA1641@gentoo.trippels.de>
 <20110405163141.GA1651@x4.trippels.de>
 <20110406085407.GA1634@x4.trippels.de>
 <4D9C2ED7.9010906@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9C2ED7.9010906@shipmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4D9C5C26.0139:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 11:13:59AM +0200, Thomas Hellstrom wrote:
> Dave, Konrad
> 
> I think we need to back out this change as soon as possible. I will
> follow up the discussion with Konrad on how we should attempt to
> handle vm passthrough as soon as things settle down a bit over here.

Ok. I believe just reverting this particular git commit

69a07f0b117a40fcc1a479358d8e1f41793617f2

does it. Doing it on top of v2.6.39-rc1:

ated: 2427 deleted: 1229), skipping inexact rename detection
Finished one revert.
[stable/ttm.pci-api-rc2 97bbc38] Revert "ttm: Utilize the DMA API for pages that have TTM_PAGE_FLAG_DMA32 set."
 1 files changed, 3 insertions(+), 23 deletions(-)

shows it to being a nice easy backout.

Dave, I stuck the revert on

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/ttm.pci-api-rc2

Please pull for rc2.

> Hopefully this week.

Thomas, waiting for your input on
http://mid.gmane.org/20110331154954.GA7695@dumpdata.com
(ignore point 1, please).


.. snip..
> >Looks like this is caused by f9820a46dd7888b05a36e81166fb1abcc47dcc3f :

Wrong git commit.

> >
> >  ttm: Utilize the DMA API for pages that have TTM_PAGE_FLAG_DMA32 set.

It is 69a07f0b117a40fcc1a479358d8e1f41793617f2

> >
> >CCing the relevant people.

How did you make the machine to do this? Did you just echo XX > to the shrinker?

> >
