Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab2CIUTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:19:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759406Ab2CIUTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:19:42 -0500
Date: Fri, 9 Mar 2012 15:19:34 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Jones <davej@redhat.com>, Yang Bai <hamo.by@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>, kernel@tesarici.cz
Subject: Re: inode->i_wb_list corruption.
Message-ID: <20120309201934.GN17489@zod.bos.redhat.com>
References: <20120306185137.GA15881@redhat.com>
 <20120306210307.GC8781@quack.suse.cz>
 <20120307072608.GA24087@localhost>
 <20120307104240.GB18658@quack.suse.cz>
 <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com>
 <20120309145713.GA21543@redhat.com>
 <20120309151951.GA30160@redhat.com>
 <CAO_0yfMYOOTvRg9=8_eYP09o0BpzSEk=8vqgNk_vV_u3-biAYA@mail.gmail.com>
 <20120309180015.GA3862@redhat.com>
 <868vj97d20.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868vj97d20.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 12:08:07PM -0800, Keith Packard wrote:
> <#part sign=pgpmime>
> On Fri, 9 Mar 2012 13:00:15 -0500, Dave Jones <davej@redhat.com> wrote:
> 
> > i915_drm_thaw is a deep nest of functions though, so this is going to be
> > hard to track down where that write is coming from. Because the corruption
> > seems to happen to pages that are already allocated, we probably can't
> > even rely on DEBUG_PAGEALLOC, though it might be worth trying.
> 
> I'm worried that the write is coming through the GTT, which would make
> sense as these look like pixel values. If this is on Ironlake (core
> I3-I7 first gen), we know there are issues when VT-d is enabled, and
> the work-around for that doesn't appear to be in place for the hibernate
> resume case.

Is the VT-d issue something in the hardware itself, or do you mean if
you have it enabled in the kernel?  We've had the intel IOMMU disabled
by default in the Fedora kernels for a while now.  At least since before
3.2 was released.

josh
