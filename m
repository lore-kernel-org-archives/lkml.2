Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2BAOnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:43:02 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48758 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2BAOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:43:00 -0500
MIME-Version: 1.0
In-Reply-To: <20120201113154.GA13723@sirena.org.uk>
References: <1328094155-3320-1-git-send-email-linus.walleij@stericsson.com>
	<20120201113154.GA13723@sirena.org.uk>
Date: Wed, 1 Feb 2012 15:42:59 +0100
Message-ID: <CACRpkdZjh6J_=DG58DkWO0bnj2Np3ujagcdOgNtYq2GfN30uRQ@mail.gmail.com>
Subject: Re: [PATCH] mfd/ab8500: support AB9540 variant
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Michel Jaouen <michel.jaouen@stericsson.com>,
        Maxime Coquelin <maxime.coquelin@st-ericsson.com>,
        Alex Macro <alex.macro@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 12:31 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Feb 01, 2012 at 12:02:35PM +0100, Linus Walleij wrote:
>
>> identifier field. If possible, we fall back on auto-detecting
>> the AB variant. The necessary deviations are factored into
>> the driver and board data.
>
> This seems a bit weird - I would expect the silicon to be more accurate
> than user provided platform data.

Well, that would have been good. As it happens, the hardware
is reusing the same ID for four widely different ASICs.

Second, if you try to even read it on older chip variants, it fails
with I2C errors. So for older chips we have to pass this through
platform data.

> I'd expect the driver to always check
> the information provided by the device and at least log if there's a
> difference.

Well, I will just get an I2C error back in the case where it is
passed from platform data, so it will sadly only delay the boot.

For newer ASICs we solve it by not providing platform data
and instead fall back to reading chip revision.

I will write this into the code as a comment so it's clear.

> It'd also be easier to review the patch if there was some description of
> the differences (or there were a series of patches adding
> parameterisation for relevant things followed by one adding the new
> device).

OK breaking it apart...

Yours,
Linus Walleij
