Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab0ETVOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:14:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43931 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab0ETVOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S5tsyvqQ8jY05ZhJFkOUfP9qLpnH5DLK280JQ3IGkshjCUn0UF6x7+iZEIasKKsQiJ
         Q/j6HcLpJccwu5TOhnRtb5xxvHM7j8j12E9q96mQ3YqoOB7sMZ/O/ny5ZOX3rMpiSBL7
         YWMs0CnsAz0hSeFLZmjeJLuwe+vQGs6IGHUJo=
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic
 time
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
In-Reply-To: <20100520092836.23bfec62@virtuousgeek.org>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
	 <20100519173449.6babbdfa@virtuousgeek.org>
	 <1274317983.2815.1.camel@maxim-laptop>
	 <1274318827.3386.3.camel@maxim-laptop>
	 <20100520092836.23bfec62@virtuousgeek.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 00:14:42 +0300
Message-ID: <1274390082.4773.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 09:28 -0700, Jesse Barnes wrote: 
> On Thu, 20 May 2010 04:27:07 +0300
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > On Thu, 2010-05-20 at 04:13 +0300, Maxim Levitsky wrote: 
> > > On Wed, 2010-05-19 at 17:34 -0700, Jesse Barnes wrote: 
> > > > On Fri, 9 Apr 2010 15:10:50 -0700
> > > > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > > 
> > > > > This set of 3 patches makes it a little more likely we'll get panic
> > > > > output onto the screen even when X is running, assuming a KMS enabled
> > > > > stack anyway.
> > > > > 
> > > > > It gets me from a blank or very sparsely populated black screen at
> > > > > panic time, to one including the full backtrace and panic output at
> > > > > panic time (tested with "echo c > /proc/sysrq-trigger" from an X
> > > > > session).
> > > > > 
> > > > > It doesn't cover every case; for instance I think it'll fail when X has
> > > > > disabled the display, but those cases need to be handled with separate
> > > > > patches anyway (need to add atomic DPMS paths for instance).
> > > > > 
> > > > > Anyway, please test these out and let me know if they work for you.
> > > > 
> > > > Ping Linus & Dave again.  Have you guys tried these?  Really, it's cool.
> > > > 
> > > Second that, just tested these patches, and these work perfectly.
> > > One more reason for me to dump nvidia driver for nouveau.
> > 
> > 
> > Unfortunately I spoke too soon.
> > 
> > 
> > After suspend to ram, system doesn't properly resume now.
> > 
> > My system is based on nvidia G86, I use latest nouveau drivers, and
> > suspend with compiz running.
> > 
> > I also patched kernel not to do vt switch on suspend/resume:
> > 
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c
> > b/drivers/gpu/drm/nouveau/nouveau_state.c
> > index 062b7f6..b3ef08b 100644
> > --- a/drivers/gpu/drm/nouveau/nouveau_state.c
> > +++ b/drivers/gpu/drm/nouveau/nouveau_state.c
> > @@ -31,6 +31,7 @@
> > #include "drm_crtc_helper.h"
> > #include <linux/vgaarb.h>
> > #include <linux/vga_switcheroo.h>
> > +#include <linux/suspend.h>
> > 
> > #include "nouveau_drv.h"
> > #include "nouveau_drm.h"
> > @@ -771,6 +772,8 @@ int nouveau_load(struct drm_device *dev, unsigned
> > long flags)
> >                 int ret = nouveau_card_init(dev);
> >                 if (ret)
> >                         return ret;
> > +
> > +               pm_set_vt_switch(0);
> >         }
> > 
> >         return 0;
> 
> Hm I don't see how my patches would have affected suspend/resume, since
> they just add "oops_in_progress" checks to a few places.  Are you sure
> something else isn't breaking your resume path?
I am sure. I just reverted them, and everything works again.
I refer to 3 patches in this thread.

Best regards,
Maxim Levitsky


> 


