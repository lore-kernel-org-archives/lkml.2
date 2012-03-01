Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab2CAUUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:20:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55405 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab2CAUUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:20:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.43.51.135 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <20120301185035.GA25359@mail.gnudd.com>
References: <cover.1329396583.git.rubini@gnudd.com>
	<5ad22021512895427a9ddee29018f5beb31a26dd.1329396583.git.rubini@gnudd.com>
	<CACRpkdaL=f7A6se63yXO=bwySC_S2yRd4r3AEfTAy6YtGi5-CQ@mail.gmail.com>
	<20120301185035.GA25359@mail.gnudd.com>
Date: Thu, 1 Mar 2012 21:20:18 +0100
Message-ID: <CACRpkda5PhQM+f49hRYvtEvFSTvx-NFWndUvXZkib5TXAGwXSw@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] gpio: add STA2X11 GPIO block
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, sameo@linux.intel.com, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 7:50 PM, Alessandro Rubini <rubini@gnudd.com> wrote:

>>> +       if (cfg == PINMUX_TYPE_FUNCTION) {
>> (...)
>>> +       case PINMUX_TYPE_OUTPUT_LOW:
>> (...)
>>> +       case PINMUX_TYPE_OUTPUT_HIGH:
>> (...)
>>> +       case PINMUX_TYPE_INPUT:
>> (...)
>>> +       case PINMUX_TYPE_INPUT_PULLUP:
>> (...)
>>> +       case PINMUX_TYPE_INPUT_PULLDOWN:
>>
>> We have created the pin control subsystem to handle things like
>> this. (Muxing and complex control.)
>>
>> Please create a driver in drivers/pinctrl/pinctrl-sta2x11.c that
>> expose both a pinctrl and a GPIOlib interface. The GPIOlib
>> interface can call into the pin control portions just fine.
>
> I'm sorry, after digging in it for a while I'm really lost.  This
> pinctrl file should be there _instead_ of the gpio file or in addition
> to it?  I see tegra has both, but u300 has only one.

Instead. Just expose three interfaces from it:

struct gpio_chip
struct irc_chip (iff it supports IRQs)
struct pinctrl_desc

> Also, this pinctrl depends on CONFIG_EXPERIMENTAL at this point in time.
> Is it wise the make the whole sta2x11 thing depend on experimental?

Another option is to wait for it to be marked non-experimental
and help fixing it up I guess, we've created it due to
shortcomings in drivers/gpio...

Yours,
Linus Walleij
