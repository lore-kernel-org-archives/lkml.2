Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab1DNI72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:59:28 -0400
Received: from 8bytes.org ([88.198.83.132]:37699 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab1DNI71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:59:27 -0400
Date: Thu, 14 Apr 2011 10:59:25 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110414085925.GD18463@8bytes.org>
References: <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <20110413215025.GA18463@8bytes.org> <4DA61D26.8050500@zytor.com> <20110413222207.GB18463@8bytes.org> <4DA6242D.90408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA6242D.90408@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:31:09PM -0700, H. Peter Anvin wrote:
> On 04/13/2011 03:22 PM, Joerg Roedel wrote:
> > On Wed, Apr 13, 2011 at 03:01:10PM -0700, H. Peter Anvin wrote:
> >> On 04/13/2011 02:50 PM, Joerg Roedel wrote:
> >>> On Wed, Apr 13, 2011 at 01:48:48PM -0700, Yinghai Lu wrote:
> >>>> -	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
> >>>> +	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<21);
> >>>
> >>> Btw, while looking at this code I wondered why the 512M goal is enforced
> >>> by the alignment. Start could be set to 512M instead and the alignment
> >>> can be aper_size as it should. Any reason for such a big alignment?
> >>>
> >>> 	Joerg
> >>>
> >>> P.S.: The box is still in the office, I will try this debug-patch
> >>>       tomorrow.
> >>
> >> The only reason that I can think of is that the aperture itself can be
> >> huge, and perhaps 512 MiB is the biggest such known. 
> > 
> > Well, that would work as well by just using aper_size as alignment, the
> > aperture needs to be aligned on its size anyway. This code only runs
> > when Linux allocates the aperture itself and if I am mistaken is uses
> > always 64MB when doing this.
> 
> Yes, I would agree with that.  The sane thing would be to set the base
> to whatever address needs to be guarded against (WHICH SHOULD BE
> MOTIVATED), and use aper_size as alignment, *unless* we are only using
> the initial portion of a much larger hardware structure that needs
> natural alignment (which isn't clear to me, I do know we sometimes use
> only a fraction of the GART, but that doesn't mean we need to
> naturally-align the entire thing, nor that 512 MiB is sufficient to do so.)

Whats allocated here is the address-space for the aperture. The code
actually allocates the memory but all it needs is the physical address
range. This range is later programmed into hardware as the GART aperture
(the area the GART remaps).
The Linux code can split the aperture if necessary for DMA-API usage and
AGP usage. In that case both users get a half of the aperture and manage
them itself.

	Joerg

