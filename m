Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2DTRZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:25:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33006 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2DTRZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:25:46 -0400
Date: Fri, 20 Apr 2012 18:25:40 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Dave Airlie <airlied@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bryce Harrington <bryce@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] [RFC] DRM locking issues during early open
Message-ID: <20120420172540.GF3467@shadowen.org>
References: <1334852525-14950-1-git-send-email-apw@canonical.com>
 <CAPM=9tzC5M-K-irN=Dw3Ai+2ExUj_vSCVYUj-qpmccHLAeaifA@mail.gmail.com>
 <20120420103110.GD3467@shadowen.org>
 <CAPM=9txRi3=0=211S7RO=OqJwVPkFfQTtMC=DAhxZUUAW3voww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txRi3=0=211S7RO=OqJwVPkFfQTtMC=DAhxZUUAW3voww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 11:34:43AM +0100, Dave Airlie wrote:
> >
> > I may be reading things wrong but the initialisation does indeed hold
> > drm_global_mutex, but and back when this first occured we would have
> > been using kernel_lock() which was at least partially reentrant right?
> 
> Yup if we slept with the BKL held we'd have allowed others to get past it,
> but also I introduced the global mutex in pci a while back

Yeah I have managed to get access to more details on the bug, and
actually we are opening the drm device successfully, we then attempt a
DRM_SETVERSION ioctl on it and it is that that appears to fail both for
1.4 and 1.1.

It is somewhat perplexing to understand how that is possible, though I
will note that the stub f_ops do not contain an ioctl op but I cannot
see any mechanism by which we might return a validly open file without
putting the driver specific ops in it.

-apw
