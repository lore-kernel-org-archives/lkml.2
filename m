Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1I1L6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 07:58:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45694 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1I1L6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 07:58:51 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17395556DC@HQMAIL01.nvidia.com>
References: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B7321777@HQMAIL01.nvidia.com>
	<CACRpkdY5ETbJxSpwJL-7KZhjOnhwrdT1=djwByek75ye=S9L9w@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1738180164@HQMAIL01.nvidia.com>
	<CACRpkdbiWUFPfF9vKV5YpSW68ZTdjwb8NhWZ_9WDoY5Q+aVfvQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF17395556DC@HQMAIL01.nvidia.com>
Date: Wed, 28 Sep 2011 13:58:50 +0200
Message-ID: <CACRpkdYx-iKPJisP7PgNynu9z3tu7s6KieFAoAOU2YO_5X2iqA@mail.gmail.com>
Subject: Re: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 2:15 AM, Stephen Warren <swarren@nvidia.com> wrote:

> But can't debugfs just get its information from the device name field in
> the mapping table? I'm not sure why the need to use that information for
> debugfs prevents the having entries with both the hog flag set and a
> device name set?

That feels unsafe - then you have some string claiming to represent the
device for that pinmux, but the system has not matched that string
against dev_name() for any real device, so it could be a lie, any string
like "foo" would do.

What I do now for U300 is complete resolution by matching dev_name
in the mapping to dev_name(device) on the struct device * actually
instantiated, which means you're 100% sure it is really mapped
to that very device.

I like this since it's much more stringent...

Yours,
Linus Walleij
