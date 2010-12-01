Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0LAPjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:39:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0LAPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:39:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Date: Wed, 1 Dec 2010 16:39:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Linus Walleij <linus.walleij@linaro.org>,
        Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local> <20101130230533.GA11342@kroah.com> <20101130234215.GE8521@n2100.arm.linux.org.uk>
In-Reply-To: <20101130234215.GE8521@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012011639.03904.arnd@arndb.de>
X-Provags-ID: V02:K0:h9zWzjdxrynjSvMUwyqdlha0tSUHFduopaR6fP6IsUB
 1M1dq7M0VuVlXwA9bhVA0P7VzSgulwAf2MkbF52siQrjO7zCWR
 B/rNhhZezmsYjjF5n6JQV2l6CnJt4cFLB26arzSDfMsRXYyguu
 UzhwPayDUprH5vjFhPhZ5BPPrt32ayBcPSdkpiJkXSfAu5j8X9
 ea2FFNShACznne6pGewgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 December 2010, Russell King - ARM Linux wrote:
> Right, so saying to ARM developers that they can't submit code which
> adds new static device structures is rather problematical then, and
> effectively brings a section of kernel development to a complete
> standstill - it means no support for additional ARM platforms until
> this issue is resolved.  (This "condition" was mentioned by Arnd
> earlier in this thread, and was put in such a way that it was now
> a hard and fast rule.)

At the embedded developer BoF in Cambridge,MA we discussed this
problem quite a bit, and my impression there was that it is a hard
rule indeed, so I said this to the best of my knowledge.

> I feel it would be better to allow the current situation to continue.
> If we start telling people that they can't use statically declared
> devices without first having an alternative, we'll end up with people
> inventing their own individual - and different - solutions to this
> problem, which could actually make the problem harder to resolve in
> the longer term.

Yes, that makes sense. We should probably start thinking about the
migration plan though. There does not seem to be a shortage of
alternatives for registering new platform devices already and once
we can get to agree on how we want it done, we can start mandating
that new drivers do it that way, while we phase out some of the
other ones.

Among the architectures that use platform devices extensively, the
various ways to register them I could find are:

* static platform_register_device:
  arm, avr32, frv, mips, m32r, sparc, sh and xtensa

* static platform_add_devices:
  arm, blackfin, m68knommu, mips, sh

* dynamic platform_device_register_simple:
  m68k, mips, powerpc, sh and x86

* dynamic platform_device_alloc/platform_device_add:
  arm, avr32, mips, powerpc, lots of drivers

* dynamic of_platform_bus_probe:
  powerpc, microblaze

* dynamic platform_device_register_resndata:
  not currently used

I was under the impression that platform_device_register_resndata is
the function that was actually meant to solve this, but there are
exactly zero users of this, except for the
platform_device_register_simple wrapper. The fact that it's currently
not used probably means either that nobody heard about it or that
the interface is lacking in some way and is actually useless for
replacing the static definitions.

	Arnd
