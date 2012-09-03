Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab2ICPUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 11:20:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48053 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2ICPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 11:20:21 -0400
Date: Mon, 3 Sep 2012 16:20:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
Message-ID: <20120903152012.GH31163@gmail.com>
References: <20120831122323.GC5962@gmail.com>
 <CACRpkdZ=C1EV4WO2b=1YLHPNhsDsQdq7Kfnpzm8i7uGRtVjJuQ@mail.gmail.com>
 <20120903094448.GB11780@pengutronix.de>
 <20120903100656.GC5782@gmail.com>
 <CACRpkdb8owKBxawAv4LVVYx5kUgZ9cUSiQ=BV0f3Pf3bHtknuQ@mail.gmail.com>
 <CAF2Aj3j25w1Nn9O6hV+=i-j1ts_p_Ucswk_M7r04S7i5BzPkHg@mail.gmail.com>
 <CACRpkdZ5VFhrbONy=0K5MFh4e6BDFckq0yqzjQ2QkW9MgwKqBg@mail.gmail.com>
 <5044BFD1.10708@nvidia.com>
 <CACRpkda0akcLRe3J=fVcyYpxHmkJmVe+c1doXQ4=vOA6iNxe2g@mail.gmail.com>
 <5044C82E.5060207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5044C82E.5060207@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 10:09:34AM -0500, Rob Herring wrote:
> On 09/03/2012 09:35 AM, Linus Walleij wrote:
> > On Mon, Sep 3, 2012 at 4:33 PM, Stephen Warren <swarren@nvidia.com> wrote:
> >> On 09/03/2012 05:58 AM, Linus Walleij wrote:
> >>> On Mon, Sep 3, 2012 at 1:32 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >>>
> >>>> No, this is wrong. Platform data should not override DT.
> >>>>
> >>>> If DT is enabled and passed, it should have highest priority.
> >>
> >> No, that's wrong. If platform data is specified, it overrides DT, so
> >> that if the DT needs any fixup, it can be provided using platform data.
> > 
> > Thanks Stephen, now there are two of us saying this, Lee please
> > follow this design pattern.
> > 
> > (Unless Rob/Grant start shouting counter-orders...)
> 
> Ideally, you only use DT or platform_data and you override DT with a new
> DTB. Hopefully we can ultimately remove platform_data or all but parts
> that can't be described in DT (i.e. function callouts).

Exactly. I don't believe that AUX_DATA() should be used as a facility to
override DT settings from platform_data.

> But if you are handling both, then I agree that platform_data should
> override DT.

I do agree with this, but I haven't stumbled over such a use-case yet.
I have only provided; clock names, DMA settings and call-back information
via AUX_DATA() thus far, and those are being removed too when a) the 
correct bindings are mainlined and b) I have the time.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
