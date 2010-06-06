Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0FFH0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 03:26:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:49146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab0FFH0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 03:26:51 -0400
Message-Id: <89khjo$fk2k1t@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,371,1272870000"; 
   d="scan'208";a="524374077"
Date: Sun, 06 Jun 2010 08:26:46 +0100
To: Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>, dri-devel@lists.sourceforge.net
Subject: Re: [2.6.35-rc regression] i915: cursor corruption on Arrandale caused by 9b8c4a0b215e
References: <20100606022115.GA26686@hexapodia.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100606022115.GA26686@hexapodia.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 19:21:15 -0700, Andy Isaacson <adi@hexapodia.org> wrote:
> My x201s (Core i7 L640 according to /proc/cpuinfo) running -rc1 exhibits
> cursor corruption when changing the cursor image (such as when moving
> out of xterm onto the desktop).  Bisection pointed to 9b8c4a0b215e and
> reverting that on top of 03cd373981 fixed the problem.  I'm running
> fvwm2 with xterm as my primary X client; the driver is
> 
> xserver-xorg-video-intel             2:2.9.1-4
> 
> The corruption generally goes away within a second or two, and seems to
> consist of the previous cursor image interleaved with the new cursor
> image on a row-by-row basis.  Some kind of cache flush issue?

Exactly; a missing move-to-GTT-domain causing the cursor data to remain in
the CPU cache.

https://bugs.freedesktop.org/show_bug.cgi?id=28335

-- 
Chris Wilson, Intel Open Source Technology Centre
