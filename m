Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965008Ab2B2Jiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:38:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964829Ab2B2Jiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:38:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.236.5 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC79@HQMAIL01.nvidia.com>
References: <1330062969-25016-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17BD8BCC79@HQMAIL01.nvidia.com>
Date: Wed, 29 Feb 2012 10:38:46 +0100
Message-ID: <CACRpkdZ-a+kyknb-q+_=TLGcNshwkLAY4918bwD7e6LzL3sWbg@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: make the pinmux-pins more helpful
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 5:44 PM, Stephen Warren <swarren@nvidia.com> wrote:

> If we do make a change like this, I'd prefer the format to be:
>
> UNCLAIMED
> "%s (HOG)", desc->owner
> desc->owner

I don't see the point, the debugfs files are supposed to be
human-readable, a human is not interested in the fact that
the pinctrl device itself is owning the pin, what is interesting is
that it is hogged.

>> I somewhat mourn the loss of being able to tell from the debugfs
>> which function is using a certain pin, does anyone have ideas on
>> how to go about fixing this properly? The root file
>> pinctrl-handles does tell it, but requires cross-referencing
>> which isn't helpful.
>
> This doesn't seem like a big deal to me; it's very easy to cross-
> reference.

Not to me it isn't, looks like I would have to create scripts to
do that for a large pin controller and that's less helpful than
just having the information there.

> That said, we could either:
>
> a) Add a field to pin_desc which indicates current usage. This would be
> set whenever the pin's mux function was set, i.e. in pinctrl_select_state()
> or pinctrl_request_gpio().

That's like re-introducing the former "function" field I guess.

Simple if I just also #ifdef CONFIG_DEBUGFS... so I'd go
for this.

> b) Add a pinctrl driver ops function which reads and prints the current
> state from HW.
>
> (and note the fact that having the debug file list the current mux
> function per pin doesn't really make sense on HW where the muxing is
> per group...)

On U300 it makes a lot of sense even thogh it is essentially
group based. When sitting with the datasheet with the pin names
and use groups it's simple to see exactly how any one pin is muxed
for the moment and troubleshoot from there.

Linus Walleij
