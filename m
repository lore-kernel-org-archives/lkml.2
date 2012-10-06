Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2JFH1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:27:19 -0400
Received: from 1wt.eu ([62.212.114.60]:35976 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2JFH1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:27:17 -0400
Date: Sat, 6 Oct 2012 09:27:04 +0200
From: Willy Tarreau <w@1wt.eu>
To: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
Subject: Re: 3.5 regression on i915
Message-ID: <20121006072704.GA22465@1wt.eu>
References: <20121005234218.GC21163@1wt.eu> <CAPM=9txTo4agvvFnY8KbF82WoCxh0Pmb1HcoEP4ZUbauL5Ws8Q@mail.gmail.com> <20121005235845.GE21163@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005235845.GE21163@1wt.eu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 01:58:45AM +0200, Willy Tarreau wrote:
> On Sat, Oct 06, 2012 at 09:48:57AM +1000, Dave Airlie wrote:
> > Any reason you don't have KMS, you'll keep hitting these non-kms bugs
> > since it has no users anymore really.
> > 
> > Granted they'll get fixed, but I suspect its a losing battle over time.
> 
> Well, back in old times every time I tried to enable it, I only ran into
> problems so I got used to disable it, which made sense since it didn't
> bring me any benefit.

OK I found why in the end. When I enable KMS, my X server fails to start
and segfaults in intel_drv.so. So I think that the comment in Kconfig
below is quite appropriate :

   config DRM_I915_KMS
        bool "Enable modesetting on intel by default"
        depends on DRM_I915
        help
          Choose this option if you want kernel modesetting enabled by default,
          and you have a new enough userspace to support this. Running old
          userspaces with this enabled will cause pain.  Note that this causes
          the driver to bind to PCI devices, which precludes loading things
          like intelfb.

Regards,
Willy

