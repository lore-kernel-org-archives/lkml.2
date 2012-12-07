Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab2LGMGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 07:06:49 -0500
Received: from antcom.de ([188.40.178.216]:52914 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab2LGMGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 07:06:48 -0500
Message-ID: <50C1DBD4.1040007@antcom.de>
Date: Fri, 07 Dec 2012 13:06:44 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de,
        wg@grandegger.com
Subject: Re: [PATCH 0/6 v10] gpio: Add block GPIO
References: <1354830456-17590-1-git-send-email-stigge@antcom.de> <20121207103643.34ca6dc5@pyramind.ukuu.org.uk>
In-Reply-To: <20121207103643.34ca6dc5@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2012 11:36 AM, Alan Cox wrote:
>> * Device interface for userland access (alternative to sysfs)
> 
> Currently we can set different permissions on different GPIO lines. Your
> driver change drives a truck through this facility.
> 
> I'm not sure there is an elegant way to snoop on the permissions set
> on the sysfs gpio nodes and the driver also breaks managing GPIO rights
> via smack/selinux/apparmor and assigning specific gpio lines to specific
> pieces of user space code.

Right. It's difficult to synchronize sysfs and dev node permissions from
the kernel. But since those permissions are set up and maintained from
userspace, maybe we can leave it to the respective facilities there?

Regarding different permissions of individual GPIOs that could end up in
a single GPIO block: You can group GPIOs into separate blocks that are
supposed to group with the same permissions. Especially, you don't need
to put all GPIOs of one gpio_chip into one block.

And finally, you are not forced to use such blocks. Use it optionally
where you group GPIOs into one bus or n-bit interface. E.g., you
typically won't give different permissions to the different lines on an
SD card interface.

Anyway - suggestions (and specific requests for necessary features of
the device interface) welcome!

Thanks in advance,

Roland
