Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1JUM21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 08:28:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52886 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1JUM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 08:28:26 -0400
MIME-Version: 1.0
In-Reply-To: <20111020154244.GA26083@opensource.wolfsonmicro.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
	<20111020023140.GC32007@S2100-06.ap.freescale.net>
	<CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
	<CACRpkdYCgY9w8UgMKLgxSsu=Veo01-YSKBWndqU_uCTE-GjZuQ@mail.gmail.com>
	<20111020141827.GB6100@sirena.org.uk>
	<CACRpkdaaUmze+W1n4NkApTX0Se1VJAmD+AJSm36QbsKVDzdnRA@mail.gmail.com>
	<20111020154244.GA26083@opensource.wolfsonmicro.com>
Date: Fri, 21 Oct 2011 14:28:25 +0200
Message-ID: <CACRpkdbJbUefH+Q0GMp+_4FhV5RqQ+KHrGnJLR6jZSNR16NbSw@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 5:42 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Oct 20, 2011 at 04:43:30PM +0200, Linus Walleij wrote:
>> In Ux500 we model our power domain switches as regulators,
>> does such a property even belong in pin control? Is there
>> one power domain switch per pin you mean, or a power switch
>> for a whole group of pins?
>
> This isn't an on/off control and in this cae it's per pin.

If this is a binary output pin, I suspect that
I suspect that what you call "off" is actually implemeted as
in this figure:
http://upload.wikimedia.org/wikipedia/commons/c/c0/Tristate_buffer.svg

In which case:
PIN_CONFIG_DRIVE_PUSH_PULL
PIN_CONFIG_DRIVE_OFF
or PIN_CONFIG_BIAS_HIGH_IMPEDANCE

Is a config pair which most often correspond to
exactly what you're doing here, albeit with a different
terminology.

However, if it is an *analog* pin....
Then it's something else.

Yours,
Linus Walleij
