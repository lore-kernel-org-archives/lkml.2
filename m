Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2FRG12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:27:28 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:48806 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab2FRG1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:27:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaNs87D+x6WUiMMmOtTdLWJoxrUN-FawuVN1F=oKi3Q=ow@mail.gmail.com>
References: <1339607167-26654-1-git-send-email-fabio.estevam@freescale.com>
	<CACRpkda6FJm4fiQ9w0Mo80_B7W09yCwMdMeqoiDUtkifJ88_RQ@mail.gmail.com>
	<CAHdPZaNs87D+x6WUiMMmOtTdLWJoxrUN-FawuVN1F=oKi3Q=ow@mail.gmail.com>
Date: Mon, 18 Jun 2012 08:27:24 +0200
Message-ID: <CACRpkdZSkQM-RCWvjRxWrU5VT0RN6eh9i4QXg-YUMn7KvtW3OQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: mxs: Use kfree to fix build error
From: Linus Walleij <linus.walleij@linaro.org>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, shawn.guo@freescale.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 8:15 AM, devendra.aaru <devendra.aaru@gmail.com> wrote:

> The pinctrl is not selectable even with make allyesconfig. is it for a
> different arch than x86?

At the request of Linus (Torvalds) machines and drivers that need pinctrl
shall select it explicitly in the Kconfig, and it's hidden for all others so
as not to confuse people and present them with strange stuff.

So currently only some ARM machines that actually use it will select it and
enable the sub-menu. But there is also a MIPS patch in the works.

> may i know which cross compiler to use to build the pinctrl subsystem :) ?

I use the prebuilt Linaro GCC toolchain:
https://launchpad.net/linaro-toolchain-binaries/+download

Put the /bin subdir in your path and e.g.:
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- mxs_defconfig
etc

Linus Walleij
