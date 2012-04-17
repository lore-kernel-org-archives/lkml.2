Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2DQGrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:47:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61851 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2DQGrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:47:18 -0400
MIME-Version: 1.0
In-Reply-To: <4F8C7839.6060104@flameeyes.eu>
References: <4F8C7839.6060104@flameeyes.eu>
Date: Tue, 17 Apr 2012 08:47:17 +0200
Message-ID: <CACRpkdaOSSA8PuTSQ4utp9JHKbBiz+iWfuPn=2WyojZxsR5a3A@mail.gmail.com>
Subject: Re: [RFC] IT87xx GPIO and other drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Diego_Elio_Petten=F2?= <flameeyes@flameeyes.eu>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        guillaume ligneul <guillaume.ligneul@oselis.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Denis Turischev <denis@compulab.co.il>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 9:51 PM, Diego Elio Pettenò
<flameeyes@flameeyes.eu> wrote:

> The GPIO pins on most of the it87xx chips are also multi-function, and
> _should not_ be user-visible, but for some of them it might make sense
> to (for instance it should be possible to drive some of the LEDs on
> it8728f-based motherboards by replacing the functions of some PINs to GPIO).
>
> For what I can tell, it should probably be a good idea to have something
> along these lines, but I'm _not_ a driver expert:
>
>  - mfd-it87xx: a platform driver, which probes the superio to check it
> to be an it87xx chip, and then reserve resources for the other drivers;
>  - hwmon/it87: no longer probes autonomously for which chip it is, and
> where it is;
>  - it87_wdt: ibidem;
>  - it8712_wdt: no clue about it, but I guess the same;
>  - gpio-it87: ibidem again;
>  - pinctrl-it87: abstracts support for the various pin-choice registers;
>  - led-it87: possibly to drive the power/network/hdd leds, akin to what
> happens with some laptops, and embedded systems.

I would suggest merging gpio-it87 and pinctrl-it87 into one driver
in drivers/pinctrl-it87.c. I don't know for sure however, since it depends
on hardware: usually these is a tight dependence between GPIO and
pinctrl (IIRC this was the case with SuperIO), and then it often makes
a lot of sense to create a composite driver, in order to just have one
state container (cookie) to pass around in the functions, and to remap
a register range only once.

The concept is explained in my pinctrl talk on a high level:
http://www.df.lth.se/~triad/papers/pincontrol.pdf

Yours,
Linus Walleij
