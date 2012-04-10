Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2DJI5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:57:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40858 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2DJI53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:57:29 -0400
Date: Tue, 10 Apr 2012 10:58:20 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120410085820.GC4115@phenom.ffwll.local>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>, dri-devel@lists.freedesktop.org
References: <4F717CE3.4040206@suse.cz>
 <4F717D80.9040207@suse.cz>
 <4F758400.3080907@suse.cz>
 <1333104359_155028@CP5-2952>
 <20120409101119.47e770b2@jbarnes-desktop>
 <4F83F3B5.8080704@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F83F3B5.8080704@suse.cz>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 10:47:49AM +0200, Jiri Slaby wrote:
> On 04/09/2012 07:11 PM, Jesse Barnes wrote:
> > On Fri, 30 Mar 2012 11:45:43 +0100 Chris Wilson
> > <chris@chris-wilson.co.uk> wrote:
> > 
> >> On Fri, 30 Mar 2012 11:59:28 +0200, Jiri Slaby <jslaby@suse.cz>
> >> wrote:
> >>> I don't know what to dump more, because iir is obviously zero
> >>> too. What other sources of interrupts are on the (G33) chip?
> >> 
> >> IIR is the master interrupt, with chained secondary interrupt
> >> statuses. If IIR is 0, the interrupt wasn't raised by the GPU.
> > 
> > I've actually seen cases where one of the PIPE*STAT regs is stuck,
> > and even if IIR is 0 we still get interrupts... Jiri can you verify
> > the PIPE*STAT regs have bits set, maybe one or more we don't check
> > for?
> 
> Note that I already attached their contents... This is what is in them
> (pipes 0 and 1):
> [ 3572.968581] i915_driver_irq_handler: 0=00000000 1=00000000
> [ 3572.977472] i915_driver_irq_handler: 0=00000000 1=00000000
> [ 3576.224839] i915_driver_irq_handler: 0=00000000 1=00000000
> [ 3576.243558] i915_driver_irq_handler: 0=00000000 1=00000000
> [ 3576.384912] i915_driver_irq_handler: 0=00000000 1=00000000
> [ 3576.403462] i915_driver_irq_handler: 0=00000000 1=00000000
> [ 3577.464100] i915_driver_irq_handler: 0=00000000 1=00000000
> [ 3577.477383] i915_driver_irq_handler: 0=00000000 1=00000000
> [ 3577.829016] i915_driver_irq_handler: 0=00020000 1=00000000
> [ 3577.830093] i915_driver_irq_handler: 0=00020000 1=00000000
> 
> I.e. the handler is called when IIR=0 and both pipe stats are 0.

Hm, can you also dump the PORT_HOTPLUG_STAT register? That's the only
other subordinate interrupt source left.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
