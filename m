Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab2DBTEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:04:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34052 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2DBTEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:04:39 -0400
Date: Mon, 2 Apr 2012 21:05:23 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [3.4-rc1][Regression][intel] Resume from suspend to disk hangs
 on restoring backlight state
Message-ID: <20120402190523.GB5260@phenom.ffwll.local>
Mail-Followup-To: Maciej Rutecki <maciej.rutecki@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <201204021939.39603.maciej.rutecki@gmail.com>
 <20120402175402.GA5260@phenom.ffwll.local>
 <201204022100.11096.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201204022100.11096.maciej.rutecki@gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 09:00:11PM +0200, Maciej Rutecki wrote:
> On poniedziałek, 2 kwietnia 2012 o 19:54:02 Daniel Vetter wrote:
> > On Mon, Apr 02, 2012 at 07:39:39PM +0200, Maciej Rutecki wrote:
> > > Last known good: 3.3
> > > Bad kernel: 3.4-rc1
> > > Subsystem: power management/suspend/dri(intel)
> > > 
> > > When I resume from suspend to disk then system hangs on this screen:
> > > http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/DSC_5479.jpg
> > > 
> > > It does not help SysRq keys. Only I can force power off by hold power
> > > button.
> > > 
> > > Dmesg:
> > > http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/dmesg-3.4-rc1.t
> > > xt
> > > 
> > > Config:
> > > http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/config-3.4.0-rc
> > > 1
> > 
> > Likely a known regression, ppgtt support broke hibernate because my code
> > doesn't restore the ppgtt page directory correctly in the thaw function.
> > 
> > Patch:
> > http://cgit.freedesktop.org/~danvet/drm-intel/commit/?h=drm-intel-fixes&id=
> > 55a254ac63a3ac1867d1501030e7fba69c7d4aeb
> > 
> > Please test whether this fixes your issue. You can also try adding
> > i915.i915_enable_ppgtt=0 to your kernel cmdline.
> > 
> > Thanks, Daniel
> 
> Patch solves problem.
> 
> Now resume hangs later on another subsystem: wireless :D

Woot, I'm off the hook ;-) Thanks for reporting this issue and testing the
patch.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
