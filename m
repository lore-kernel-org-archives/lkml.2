Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0F3Hbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:31:52 -0400
Received: from smtp-out-153.synserver.de ([212.40.180.153]:1036 "HELO
	smtp-out-153.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751758Ab0F3Hbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:31:51 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 25933
Date: Wed, 30 Jun 2010 09:31:45 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, alexdeucher@gmail.com
Subject: Re: [git pull] drm fixes + agp + one fb patch (bisected)
Message-ID: <20100630073145.GA1722@arch.tripp.de>
References: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
 <20100630065440.GA1736@arch.tripp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630065440.GA1736@arch.tripp.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 08:54:40AM +0200, Markus Trippelsdorf wrote:
> On Wed, Jun 30, 2010 at 02:03:04AM +0100, Dave Airlie wrote:
> > 
> > one fb layer fix in a flag I introduced,
> > 
> > the rest are drm fixes:
> > radeon fixes: the larger ones in the command stream checker for older cards,
> > which was causing a lot of userspace apps to fail. Also some powerpc server fixes.
> > along with some updates to the evergreen command stream checker introduced in -rc1.
> > 
> > agp: fix issue with warning on memory allocation + fallback to vmalloc.
> > ttm: fix regression introduced in -rc1 in memory allocation paths.
> > 
> > The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:
> > 
> >   Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)
> > 
> 
> I've tested these patches and they break my setup (RS780). On reboot, the
> monitor goes straight to powersaving mode and no framebuffer is shown.

This is the result of the bisection:

07d4190327b02ab3aaad25a2d168f79d92e8f8c2 is the first bad commit
commit 07d4190327b02ab3aaad25a2d168f79d92e8f8c2
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Sat Jun 12 11:50:13 2010 -0400

    drm/radeon/kms: fix bandwidth calculation when sideport is present
    
    Fixes fdo bug 27529:
    https://bugs.freedesktop.org/show_bug.cgi?id=27529
    
    Reported-by: steckdenis@yahoo.fr
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
    Cc: stable <stable@kernel.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

-- 
Markus
