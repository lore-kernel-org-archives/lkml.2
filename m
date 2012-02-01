Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2BAM3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 07:29:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62643 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2BAM3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 07:29:30 -0500
MIME-Version: 1.0
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384ED2897780@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384ED2897780@EAPEX1MAIL1.st.com>
Date: Wed, 1 Feb 2012 13:29:29 +0100
Message-ID: <CACRpkdbB2ALMeBZfba7rz+NyNC-z-XfT4wuHLGgxMJ+iFYwomg@mail.gmail.com>
Subject: Re: Handling <Ctrl-c> like events in 's_power' implementation when we
 have a GPIO controlling the sensor CE
From: Linus Walleij <linus.walleij@linaro.org>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin VINCENT <rabin.vincent@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 6:01 AM, Bhupesh SHARMA <bhupesh.sharma@st.com> wrote:

> Our board has a I2C controlled camera sensor whose Chip Enable (CE)
> pin is driven via a GPIO. This GPIO is made available by a I2C-to-GPIO
> expander chip (STMPE801, see user manual [1])
(...)
> the I2C controller driver
> (we use the standard SYNOPSYS designware device driver present in mainline,
> see [3]) returns -ERESTARTSYS in response to the write command we had requested
> for putting the sensor to power-off state (as it has received the <ctrl-c> kill
> signal).

So what happens if you go into the I2C driver and replace all things
that look like this:

ret = wait_for_completion_interruptible_timeout(&dev->cmd_complete, HZ);

With this:
ret = wait_for_completion_timeout(&dev->cmd_complete, HZ);

(Non-interruptible.)

This is usually the problem.

Yours,
Linus Walleij
