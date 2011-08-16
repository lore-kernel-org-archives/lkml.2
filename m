Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1HPOhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:37:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab1HPOhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:37:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC PATCH v2 00/13] arm/tegra: Initialize GPIO & pinmux from DT
Date: Tue, 16 Aug 2011 16:37:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com> <201108161509.17157.arnd@arndb.de> <CACRpkdaVx=6AJ5DFjVN1ZYQ++hu9pT6WxD9n+pqmYVaCf1xawg@mail.gmail.com>
In-Reply-To: <CACRpkdaVx=6AJ5DFjVN1ZYQ++hu9pT6WxD9n+pqmYVaCf1xawg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161637.16620.arnd@arndb.de>
X-Provags-ID: V02:K0:XOsNxKqcHhoN6luYnfGhFnnLxN4IkFY7H3F5xWlncWI
 ITiwYAk3E3Zi4KVb8mLJ2ICwclbN4KXXWDgRIJIidGYgcsGuB3
 4nislUukht3vhQZdmj5p3t87jz1/JtDd+NxhTtPdzESma/VeOP
 K2WsB/JaXsuD7Z74YvcPjT39+CJJjGUzu706sS7+0VXfQ6jgUP
 MM5t+X39/4gv9j+3Znttw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 August 2011, Linus Walleij wrote:
> One specific thing worries me: Grant asked me to make sure
> to NOT create a global pin number space for the pinmuxes (and thus
> pinctrl). This means that in order to proceed, mappings of pinmux
> groups or pincontrol (such as bias) groups, each device using such
> an entity need to reference the intended pincontroller/mux instance.
> 
> Say mmc instance 0 need pingroup foo on pincontroller bar
> means that there must be a specific reference from mmc.0:s
> struct device * to pinctrl bar:s struct device *. Maybe this is
> peanuts in DT, sorry not enough insight.

I think what you are looking for is the equivalent of the
interrupt-parent property for pinmux. The idea is that each
node in the device tree can point to a device managing the
pinmux, so reference would point to a local number in that
space. We have discussed this for the GPIO case already, and
I suspect that the two should be identical (gpio-controller
and pinmux-controller using the same device node and same
property to refer to them). Since the pinmux-parent
(gpio-parent, ...) property gets inherited by all child
devices, you only need to set it once at the root of the
device tree for the simple case where there is only one
controller.

	Arnd
