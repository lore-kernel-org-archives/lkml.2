Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab2DBTAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:00:18 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64304 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2DBTAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:00:16 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [3.4-rc1][Regression][intel] Resume from suspend to disk hangs on restoring backlight state
Date: Mon, 2 Apr 2012 21:00:11 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.7.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <201204021939.39603.maciej.rutecki@gmail.com> <20120402175402.GA5260@phenom.ffwll.local>
In-Reply-To: <20120402175402.GA5260@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204022100.11096.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 2 kwietnia 2012 o 19:54:02 Daniel Vetter wrote:
> On Mon, Apr 02, 2012 at 07:39:39PM +0200, Maciej Rutecki wrote:
> > Last known good: 3.3
> > Bad kernel: 3.4-rc1
> > Subsystem: power management/suspend/dri(intel)
> > 
> > When I resume from suspend to disk then system hangs on this screen:
> > http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/DSC_5479.jpg
> > 
> > It does not help SysRq keys. Only I can force power off by hold power
> > button.
> > 
> > Dmesg:
> > http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/dmesg-3.4-rc1.t
> > xt
> > 
> > Config:
> > http://mrutecki.pl/download/kernel/3.4-rc1/suspend_resume/config-3.4.0-rc
> > 1
> 
> Likely a known regression, ppgtt support broke hibernate because my code
> doesn't restore the ppgtt page directory correctly in the thaw function.
> 
> Patch:
> http://cgit.freedesktop.org/~danvet/drm-intel/commit/?h=drm-intel-fixes&id=
> 55a254ac63a3ac1867d1501030e7fba69c7d4aeb
> 
> Please test whether this fixes your issue. You can also try adding
> i915.i915_enable_ppgtt=0 to your kernel cmdline.
> 
> Thanks, Daniel

Patch solves problem.

Now resume hangs later on another subsystem: wireless :D

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl
