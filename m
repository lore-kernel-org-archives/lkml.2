Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab2EDNOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 09:14:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62498 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab2EDNOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 09:14:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 02/02] mach-shmobile: KZM9D board prototype support
Date: Fri, 4 May 2012 13:14:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, horms@verge.net.au,
        linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, lethal@linux-sh.org,
        olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520> <20120503144703.6390.20689.sendpatchset@w520>
In-Reply-To: <20120503144703.6390.20689.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041314.08701.arnd@arndb.de>
X-Provags-ID: V02:K0:dSYkvzztwznCPr8wdfmFIuiRRHPdHLId/S2jtIyMZdP
 ZVPPaGZ1Jmg4HmHWUaip1y7cVPonfr5THHxUMr1IEIhEqAk9aK
 f77HYB6RK6qfi16qnon7aVLZojEeXHQrYOaYOriE7xWkRBPxSW
 Cnzi9oweqhTGohOc+MOM/Il+Jk5oSUPYy0J8rT4/WTeMtf+ZIg
 xZGp+qZtabR/SBH/qeupWci/Rl/5AiukJctWdGzVrHGWanoyWp
 tZpTFuGRrDxqKw+lV/zjIXYxZ0z3NYFNRS4rKINcd7OWYmgTvJ
 3cOCIKnpC4ZCBrmVTEfSbZf5PI9LnKT2G5eOn8b7inm98Vf/1V
 NiJRDwwJJpk67U9v7gf0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 May 2012, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add experimental KZM9D board support that makes
> use of the Emma Mobile EV2 SoC code.
> 
> Nothing except serial ports and timer are supported
> at this point. On-board ethernet support can be
> added after proper GPIO bindings are implemented.
> Without GPIO we cannot make use of external IRQs.
> 
> Not-yet-signed-off-by: Magnus Damm <damm@opensource.se>

Given that this doesn't do anything, I see no reason to leave this
machine based on ATAG rather than DT probing:

+MACHINE_START(KZM9D, "kzm9d")
+       .map_io         = emev2_map_io,
+       .init_early     = emev2_add_early_devices,
+       .nr_irqs        = NR_IRQS_LEGACY,
+       .init_irq       = emev2_init_irq,
+       .handle_irq     = gic_handle_irq,
+       .init_machine   = emev2_add_standard_devices,
+       .timer          = &shmobile_timer,
+MACHINE_END

Just make this DT_MACHINE_START and add a minimal .dts file for
it that has the right compatible value. That will already enable
people to add devices in their .dts files without touching
the platform code.

It would also be really easy to just add DT support for the three
devices you actually support (GIC, STI, uart), because two of
them already have bindings and the third one is a new driver.
When we discussed this new soc earlier, you said that using DT
based booting would be extra work, but given the set of devices
that you are putting into this, I don't think that argument holds
any more.

	Arnd
