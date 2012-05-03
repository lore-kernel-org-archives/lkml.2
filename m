Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab2ECVOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:14:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40005 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2ECVOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:14:33 -0400
Date: Thu, 3 May 2012 23:15:38 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
Message-ID: <20120503211537.GN4983@phenom.ffwll.local>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Slaby <jirislaby@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <20120409101119.47e770b2@jbarnes-desktop>
 <4F83F3B5.8080704@suse.cz>
 <20120410092619.26a15165@jbarnes-desktop>
 <4F8477D1.4080102@suse.cz>
 <20120410113448.540e4c1d@jbarnes-desktop>
 <4F848F88.7060009@suse.cz>
 <20120410203212.GN4115@phenom.ffwll.local>
 <20120410133411.52dc52ed@jbarnes-desktop>
 <20120411104012.GI4296@phenom.ffwll.local>
 <4FA2E2D8.5050303@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA2E2D8.5050303@suse.cz>
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:56:08PM +0200, Jiri Slaby wrote:
> On 04/11/2012 12:40 PM, Daniel Vetter wrote:
> > On Tue, Apr 10, 2012 at 01:34:11PM -0700, Jesse Barnes wrote:
> >> On Tue, 10 Apr 2012 22:32:12 +0200
> >> Daniel Vetter <daniel@ffwll.ch> wrote:
> >>
> >>> On Tue, Apr 10, 2012 at 09:52:40PM +0200, Jiri Slaby wrote:
> >>>> Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> >>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >>>>
> >>>> I tried 3.2 and 3.3. Although the spurious interrupts were always
> >>>> there, they occurred with frequency lower by a magnitude (15 vs. 300
> >>>> after X starts). So I bisected that and it lead to a commit which
> >>>> fixes bad tiling for me:
> >>>> http://cgit.freedesktop.org/~ickle/linux-2.6/commit/?h=for-jiri&id=79710e6ccabdac80c65cd13b944695ecc3e42a9d
> >>>
> >>> Pipelined fencing is pretty much just broken and we'll completely rip it
> >>> out in 3.5. Does this also happen with 3.4-rc2?
> >>
> >> Does INTx- stay that way?  Or does it frequently read INTx+ if you
> >> sample it a lot?  If it stays as INTx-, then something other than the
> >> GPU is getting stuck (though it's possible this could be related to
> >> pipelined fencing, if the fences are programmed to point at some funky
> >> memory space).
> 
> Hi and sorry for the delay. It stays INTx-. And I tested that with patch
> removing fencing.
> 
> > Shot in the dark, let's disable msi a bit. Can you try the below patch?
> 
> Yeah, no IRQ_NONE at the end of i915_driver_irq_handler now. So MSI is
> busted, either in the card, the chipset or the kernel. Any idea how to
> find out?

Ok, so MSI is busted. Can you please paste lspci -nn for you intel gpu?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
