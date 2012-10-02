Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2JBCW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:22:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41892 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2JBCW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Oct 2012 19:22:34 -0700
X-Google-Sender-Auth: 5ZMqm9lOkdhreKrGQDj585FXhVc
Message-ID: <CA+55aFwoDOdKv9wcqEPkE76+w2TCz+419qp94T3_70jK9dR3-A@mail.gmail.com>
Subject: Re: [GIT PULL 0/12] ARM: soc: updates for 3.7, first batch
To: Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 4:56 PM, Olof Johansson <olof@lixom.net> wrote:
>
> Here is the first batch of pull requests for arm-soc for this merge
> window. Some of them are tiny, and we will probably start to combine
> them into slightly larger misc branches in the future. I didn't do it
> this time around since the dependencies between branches ended up quite
> complex this time around.

Ok, I've merged them all. As usual, my end result is slightly
different from yours, although the differences are pretty small.

 - I added exynos4210-trats.dtb to the "dtb-$(CONFIG_ARCH_EXYNOS)"
case in arch/arm/boot/dts/Makefile

   That seemed to be the right thing, otherwise that dtb file isn't
actually accessed from anything. Hmm?

 - Commit dbc04161048d ("ARM: OMAP: Split plat/hardware.h, use local
soc.h for omap2+") added the line

    #include "soc.h"

   to arch/arm/mach-omap2/omap_l3_noc.c, and I left it in as it moved
into drivers/bus/.

   My resolution is quite possibly wrong, but I didn't know what the
right thing to do was. Please double-check.

 - non-semantic order/whitespace difference for
CONFIG_CLKSRC_ARM_GENERIC in drivers/clocksource/Makefile.

   I didn't want to mix the generic case up with the random cases.

Anyway, you should double-check the merges, the "soc.h" one in
particular is suspect.

          Linus
