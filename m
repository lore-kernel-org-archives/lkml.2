Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab2EaBvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 21:51:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42618 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab2EaBvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 21:51:47 -0400
MIME-Version: 1.0
In-Reply-To: <349645b61d0b28f6e84f7ae1f2c8c28e12a11d92.1338398567.git.rubini@gnudd.com>
References: <cover.1338398567.git.rubini@gnudd.com>
	<349645b61d0b28f6e84f7ae1f2c8c28e12a11d92.1338398567.git.rubini@gnudd.com>
Date: Thu, 31 May 2012 09:51:14 +0800
Message-ID: <CACRpkdZ79=B8N7omxYY4UPotg8gYotfLeBRViYMr8hA-Uhie0w@mail.gmail.com>
Subject: Re: [PATCH RFC 2/3] i2c-nomadik: turn the platform driver to an amba driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Alessandro Rubini <rubini@gnudd.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 1:45 AM, Alessandro Rubini <rubini@gnudd.com> wrote:

> The i2c-nomadik gateware is really a PrimeCell APB device. By hosting
> the driver under the amba bus we can access it more easily, for
> example using the generic pci-amba driver. The patch also fixes the
> mach-ux500 users to register an AMBA device, not a platform device.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Cc: STEricsson_nomadik_linux@list.st.com
> Cc: Linus Walleij <linus.walleij@stericsson.com>

This will affect Lee Jones' device tree bindings for the same device.

You will need some add-on patch to the db8500 device tree moving this
over to the AMBA (PrimeCell) bus abstraction.

Lee can you test this and help Alessandro add the proper chunks to
the device tree as well?

Apart from that this looks good to me, I'll test it on the MOP500
as soon as I can.

Yours,
Linus Walleij
