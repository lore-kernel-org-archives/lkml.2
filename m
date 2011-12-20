Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab1LTRhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:37:05 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:33002 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1LTRg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:36:56 -0500
Date: Tue, 20 Dec 2011 12:35:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com
Subject: Re: [PATCH] fixes to drm-next - TTM DMA code (v1)
Message-ID: <20111220173552.GA6647@phenom.dumpdata.com>
References: <1323720569-15435-1-git-send-email-konrad.wilk@oracle.com>
 <20111213160753.GC2339@homer.localdomain>
 <4EE77C02.1000103@vmware.com>
 <20111213164031.GA32052@phenom.dumpdata.com>
 <4EEF95B3.9000204@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEF95B3.9000204@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EF0C7B5.00E9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 08:51:15PM +0100, Thomas Hellstrom wrote:
> On 12/13/2011 05:40 PM, Konrad Rzeszutek Wilk wrote:
> >On Tue, Dec 13, 2011 at 05:23:30PM +0100, Thomas Hellstrom wrote:
> >>On 12/13/2011 05:07 PM, Jerome Glisse wrote:
> >>>On Mon, Dec 12, 2011 at 03:09:26PM -0500, Konrad Rzeszutek Wilk wrote:
> >>>>Jerome pointed me to some accounting error in the DMA API debugging code and
> >>>>while I can't figure it out yet, I did notice some extreme slowness - which
> >>>>is due to the nouveau driver calling the unpopulate (now that unbind +
> >>>>unpopulate are squashed) quite a lot (this is using Gnome Shell - I think GNOME2
> >>>>did not have those issues but I can't recall).
> >>>>
> >>>>Anyhow these patches fix the 50% perf regression I saw and also some minor bugs
> >>>>that I noticed.
> >>>>
> >>>Gonna review those today and test them.
> >>>
> >>>Cheers,
> >>>Jerome
> >>Hi!
> >>
> >>I'm not whether any drivers are still using the AGP backend?
> >Uh, probably they do if the cards are AGP?
> >The problem I encountered was with an PCIe Nvidia card:
> >
> >01:00.0 VGA compatible controller: nVidia Corporation G84 [GeForce 8600 GT] (rev a1
> >
> >>Calling unpopulate / (previous clear) each time unbind is done
> >>should be quite
> >>inefficient with that one, as AGP sets up its own data structures
> >>and copies page tables
> >>on each populate. That should really be avoided unless there is a
> >>good reason to have it.
> >nouveau_bo_rd32 and nv50_crtc_cursor_set showed up as the callers that
> >were causing the unpopulate calls. It did happen _a lot_ when I moved the
> >cursor madly.
> 
> Konrad, Jerome
> Was there a resolution to this. If the ttm_tt rewrite results in
> unpopulate being called more often than before,
> and that causes performance regressions, that must be fixed as soon
> as possible.

I am waiting for Jerome to look over my patches. Next week I was
going to setup a test-bed with an Radeon and Nvidia AGP card
and bootup two kernels - one without the ttm_bind/ttm_populate
squashing and one with it.

Then run some benchmark code.. Thought not sure what kind of benchmark
code I should run? Any thoughts? The regression I observed were just by
moving the mouse around but that is not very "scientfic".

openareana? alien? etuxracer? Any of them offer some timed demo mode
to get an idea of performance impact?
