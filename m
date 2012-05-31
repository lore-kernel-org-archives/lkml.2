Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2EaKQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:16:56 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38153 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2EaKQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:16:55 -0400
MIME-Version: 1.0
In-Reply-To: <4FC72DDF.7080209@codethink.co.uk>
References: <cover.1338398567.git.rubini@gnudd.com>
	<349645b61d0b28f6e84f7ae1f2c8c28e12a11d92.1338398567.git.rubini@gnudd.com>
	<CACRpkdZ79=B8N7omxYY4UPotg8gYotfLeBRViYMr8hA-Uhie0w@mail.gmail.com>
	<4FC72DDF.7080209@codethink.co.uk>
Date: Thu, 31 May 2012 18:16:54 +0800
Message-ID: <CACRpkdZpjn0RBGY+CqqSW3ip0MSQUJSaqN0GD=a4THnPHNM-jg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] i2c-nomadik: turn the platform driver to an amba driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Alessandro Rubini <rubini@gnudd.com>, Lee Jones <lee.jones@linaro.org>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 4:37 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> On 31/05/12 02:51, Linus Walleij wrote:
>>
>> You will need some add-on patch to the db8500 device tree moving this
>> over to the AMBA (PrimeCell) bus abstraction.
>
> What does AMBA win us over the platform device here?

In Alessandro's case I guess it's that he can use his PCI-to-AMBA wrapper, and
there is no similar PCI-to platformdevice wrapper. So it saves some work
on his part.

But since the device has PrimeCell ID registers, this is really the
right thing to
do anyway, since autodetecting from hardware is allways NiceToDo(TM).
Else ST and us shouldn't have put the magic numbers (0xB105F00D) in there
anyway.

Yours,
Linus Walleij
