Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2EJPxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:53:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab2EJPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:53:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 02/12] pinctrl: basic Nomadik pinctrl interface
Date: Thu, 10 May 2012 15:53:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
References: <1336470270-23518-1-git-send-email-linus.walleij@stericsson.com> <CACRpkdaiTsaBT=20UUOx2mYsK4r5rArVqXfU9LMObFVb3iEA9w@mail.gmail.com> <CACRpkdZ+8n-E_8nyq-kO=Y+GYekkjiNXd3nzTqFnxLszpuKKPg@mail.gmail.com>
In-Reply-To: <CACRpkdZ+8n-E_8nyq-kO=Y+GYekkjiNXd3nzTqFnxLszpuKKPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205101553.11304.arnd@arndb.de>
X-Provags-ID: V02:K0:1I/X/ww2+QPDOBpyMFFT7Mbi1uOCCK3YS6HS/XFlXLN
 /7t+dqfSIwNDozsMQKRh8/ii+P579BpnZ0rbSybn9PqHK+L1WB
 RsPT+ZxZDVlYliu0BRm3726P3/m5U8yR2b0QzCICsmobhPDqiy
 PmLIX03FRqc2Ta42FHb3CZ3fITdl9Fe1bqkhkoI0MfXOx5jTi6
 UVDYopCi8hNzYTl89nGVRseTnScdqN3KF515nsN01jyNzoX5+r
 MtnXtBdunllGCHNbl/ucRX/q71qwq3oXbzpKQOT3dfmTFdnosy
 kGxymAa5s1U5viVvRkO7agdJF0whySmWFsFCqRlO/zdgcwZ8o7
 /btBGkMyrHoxejg0Qep4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 May 2012, Linus Walleij wrote:
> Then it's probably a good idea to actually loop in Arnd too...
> sorry for missing it!
> 
> On Thu, May 10, 2012 at 5:10 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Wed, May 9, 2012 at 10:34 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
> >>> +static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
> >>
> >>> +     /* Poke in other ASIC variants here */
> >>> +     if (platid->driver_data == PINCTRL_NMK_DB8500)
> >>> +             nmk_pinctrl_db8500_init(&npct->soc);
> >>
> >> Other platforms have a unique top-level driver for each variant, with
> >> the probe() function for each variant calling into a utility function.
> >> That way, the common/utility code doesn't need to contain a
> >> table/list/... of all the variants. Can the same approach be used here?
> >
> > Of course I could do it that way, but it's not using this feature
> > of the driver base to have a string identifier telling which version
> > it is.
> >
> > Since I'm unsure, let's ask Arnd.
> >
> > Arnd, what is your preferred design pattern of:
> >
> > A) sub-drivers that register one struct platform_driver per
> >  variant, then calls into a shared core driver, or
> >
> > B) a shared core driver registering one platform_driver
> >  with several struct platform_device_id that then call
> >  sub-drivers depending on which one is found
> >
> > Either way is actually OK for me, but I was thinking if one
> > is preferred over the other.

Out of those two, I'd always pick B.

In cases where the variants are different enough that you want to
put them into separate files, I'd do

C) Make the common code one module that just exports symbols but
registers no platform_driver at all, then put each variant into
its own module that binds to one ID and calls the exported
functions from the common module.

	Arnd
