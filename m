Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab2FNR0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:26:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57169 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2FNRZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:25:49 -0400
MIME-Version: 1.0
In-Reply-To: <4FD9A328.9080000@linaro.org>
References: <201206140804.39083.arnd@arndb.de>
	<cover.1339447570.git.rubini@gnudd.com>
	<4a198618063924b68182279ffd56c335d621f542.1339447570.git.rubini@gnudd.com>
	<20120614081758.GA19648@mail.gnudd.com>
	<4FD9A328.9080000@linaro.org>
Date: Thu, 14 Jun 2012 19:25:48 +0200
Message-ID: <CACRpkdZfherHBEXcwaco1zeK-gW=3x-rGXTfNc4QwwWfLk_JRA@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] i2c-nomadik: turn the platform driver to an amba driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        w.sang@pengutronix.de
Cc: Alessandro Rubini <rubini@gnudd.com>, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, linux@arm.linux.org.uk,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        linux-i2c@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 10:39 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On 14/06/12 09:17, Alessandro Rubini wrote:
>>>
>>> You change only one half of ux500 here: the part where the device
>>> gets defined statically, but not not the definition in the
>>> device-tree.
>>
>> Yes, I'm aware. That's why I added Lee Jones as Cc:, on Linusw's
>> suggestion.  Lee told me to go ahead and he'll fix the DT stuff.
>
> I did?

Yes :-)

> I have already DT:ed this driver. There are 3 patches on the MLs currently.
>
>> [PATCH 1/3] i2c: Add Device Tree support to the Nomadik I2C driver
>> [PATCH 2/3] ARM: ux500: Add i2c configurations to the Device Tree for
>> DB8500 based devices
>> [PATCH 3/3] Documentation: Device Tree binding information for i2c-nomadik
>> driver
>
> I'm more than happy for you to base your patches on these and make the
> necessary changes. Off hand, I think the only changes you'll need to make is
> the probing from DT itself.

Depends on whether this patch or yours go in first I guess. Which
is up to Wolfram. What I know is that Alessandros patches are
ready to merge IMO.

> So something like:
>
>    -                       compatible = "stericsson,db8500-i2c", "st,nomadik-i2c";
>    +                       compatible = "st,nomadik-i2c", "arm,primecell";

Yep that should do it.

Which brings me to the fear of what happens the day we have
deployed device trees out there and just cannot change things
like this easily :-/

Yours,
Linus Walleij
