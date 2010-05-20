Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab0ETQaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:30:21 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:44150 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752691Ab0ETQaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:30:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BNOrhA8rHei/jIzR89a8E0De72KNQ7IspT7jDOWhKRFXsj5dKwmT5m02Gh7ZZyQy5E/DWsIMZVGXb7xk31uHKUCOet0MH5rORirzJjujTe+Js3NCmUhk9Hd1gl0Q6iLH;
Date: Thu, 20 May 2010 09:28:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic
 time
Message-ID: <20100520092836.23bfec62@virtuousgeek.org>
In-Reply-To: <1274318827.3386.3.camel@maxim-laptop>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
	<20100519173449.6babbdfa@virtuousgeek.org>
	<1274317983.2815.1.camel@maxim-laptop>
	<1274318827.3386.3.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 04:27:07 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Thu, 2010-05-20 at 04:13 +0300, Maxim Levitsky wrote: 
> > On Wed, 2010-05-19 at 17:34 -0700, Jesse Barnes wrote: 
> > > On Fri, 9 Apr 2010 15:10:50 -0700
> > > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > 
> > > > This set of 3 patches makes it a little more likely we'll get panic
> > > > output onto the screen even when X is running, assuming a KMS enabled
> > > > stack anyway.
> > > > 
> > > > It gets me from a blank or very sparsely populated black screen at
> > > > panic time, to one including the full backtrace and panic output at
> > > > panic time (tested with "echo c > /proc/sysrq-trigger" from an X
> > > > session).
> > > > 
> > > > It doesn't cover every case; for instance I think it'll fail when X has
> > > > disabled the display, but those cases need to be handled with separate
> > > > patches anyway (need to add atomic DPMS paths for instance).
> > > > 
> > > > Anyway, please test these out and let me know if they work for you.
> > > 
> > > Ping Linus & Dave again.  Have you guys tried these?  Really, it's cool.
> > > 
> > Second that, just tested these patches, and these work perfectly.
> > One more reason for me to dump nvidia driver for nouveau.
> 
> 
> Unfortunately I spoke too soon.
> 
> 
> After suspend to ram, system doesn't properly resume now.
> 
> My system is based on nvidia G86, I use latest nouveau drivers, and
> suspend with compiz running.
> 
> I also patched kernel not to do vt switch on suspend/resume:
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c
> b/drivers/gpu/drm/nouveau/nouveau_state.c
> index 062b7f6..b3ef08b 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_state.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_state.c
> @@ -31,6 +31,7 @@
> #include "drm_crtc_helper.h"
> #include <linux/vgaarb.h>
> #include <linux/vga_switcheroo.h>
> +#include <linux/suspend.h>
> 
> #include "nouveau_drv.h"
> #include "nouveau_drm.h"
> @@ -771,6 +772,8 @@ int nouveau_load(struct drm_device *dev, unsigned
> long flags)
>                 int ret = nouveau_card_init(dev);
>                 if (ret)
>                         return ret;
> +
> +               pm_set_vt_switch(0);
>         }
> 
>         return 0;

Hm I don't see how my patches would have affected suspend/resume, since
they just add "oops_in_progress" checks to a few places.  Are you sure
something else isn't breaking your resume path?

-- 
Jesse Barnes, Intel Open Source Technology Center
