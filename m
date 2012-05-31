Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab2EaIAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:00:51 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:53470 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757942Ab2EaIAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:00:49 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: Lots of i915/drm spew on 3.4
To: Dave Jones <davej@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>, Dave Airlie <airlied@redhat.com>,
        Rob Clark <rob.clark@linaro.org>
In-Reply-To: <20120530222651.GA22449@redhat.com>
References: <20120530213128.GA10407@redhat.com> <CAKMK7uE7RtzFd1RR4gyOaStSEisircr7gC7sz5BwVNiy2EtV+g@mail.gmail.com> <20120530215848.GB19223@redhat.com> <20120530222651.GA22449@redhat.com>
Date: Thu, 31 May 2012 08:59:57 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1338451231_375838@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012 18:26:51 -0400, Dave Jones <davej@redhat.com> wrote:
> On Wed, May 30, 2012 at 05:58:48PM -0400, Dave Jones wrote:
>  > On Wed, May 30, 2012 at 11:51:54PM +0200, Daniel Vetter wrote:
>  >  > On Wed, May 30, 2012 at 11:31 PM, Dave Jones <davej@redhat.com> wrote:
>  >  > > On this hardware:
>  >  > >
>  >  > > 00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02)
>  >  > >
>  >  > > I get this every boot with Linus current tree (up to af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76)
>  >  > 
>  >  > Just a quick question, is this a regression? 
>  > 
>  > seems so, I don't see it on 3.3

The WARN is new, the problem is old.

commit c543188afb7a83e66161c026dc6fd5eb38dc0b63
Author: Paulo Zanoni <paulo.r.zanoni@intel.com>
Date:   Tue May 15 18:09:02 2012 -0300

    drm: add generic ioctls to get/set properties on any object
    
    Useless for connector properties (since they already have their own
    ioctls), but useful when we add properties to CRTCs, planes and other
    objects.
    
    Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
    Reviewed-by: Rob Clark <rob.clark@linaro.org>
    Tested-by: Rob Clark <rob.clark@linaro.org>
    Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

Before that commit we had no idea that we had run out of property slots.
I think the WARN is genuine, but maybe we should just bump the count set
it to WARN_ONCE and hope the conversion to lists arrives sooner rather
than latter.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
