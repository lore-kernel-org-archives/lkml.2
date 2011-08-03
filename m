Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab1HCAGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 20:06:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40749 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab1HCAGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 20:06:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110722090317.GH2622@htj.dyndns.org>
References: <CAN8TOE9CCSiS2koyx=UsZj=9KwaWZW5yDjUUqgJf2=qZU70k1w@mail.gmail.com>
	<20110713131407.GN2872@htj.dyndns.org>
	<CAN8TOE9Rjujf9aLQGONDULNasFiQmVkiUPWUDX=Vf0Nx2pka7w@mail.gmail.com>
	<20110721084917.GE3455@htj.dyndns.org>
	<CAN8TOE_dCg6Wi_trE97hXjBPnZi4jpLyoeUEVrbMpgDH-BwKWA@mail.gmail.com>
	<20110722090317.GH2622@htj.dyndns.org>
Date: Tue, 2 Aug 2011 17:06:13 -0700
Message-ID: <CAN8TOE8ZoE0xRvLPhDZtKZSwXg1mQLGtp8f2C75S+XuCrFM1YA@mail.gmail.com>
Subject: Re: ahci_start_engine compliance with AHCI spec
From: Brian Norris <computersforpeace@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jgarzik@pobox.com>,
        Michael Leun <lkml20100708@newton.leun.net>,
        linux-kernel@vger.kernel.org, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I wanted to follow up a bit on your last comments.

On Fri, Jul 22, 2011 at 2:03 AM, Tejun Heo <tj@kernel.org> wrote:
> The problem is that both my and your approach aren't ultimately safe
> on this particular IP block.  I don't think it's possible make things
> completely safe for it.  There's no mutual exclusion against PHY
> events - be it flaky signal, power surge or actual hotplug - and
> driver operation.  No matter how careful the driver behaves, if PHY
> events happen after the last check before starting DMA engine, DRQ may
> be set by the time driver gets to it.

Can DRQ be set from 0->1 without a software-initiated action? I didn't
think it was directly tied to PHY events, and so we can fairly well
predict that it will remain 0.

On the other hand, PxSSTS.DET can be affected by PHY, but I don't
believe DET != 3 directly triggers this hardware bug.

> The IP block you're dealing with is inherently buggy.  What the spec
> means, I think, is the DMA engine might not start or behave properly
> if enabled while DRQ is set, which is fine.  Driver will notice that,
> reset stuff and retry.  It is *completely* different from "the
> controller becomes brick until power cycled if that happens".  So, we
> can work around all we want but that is one buggy controller.  If
> possible, please tell the manufacturer or licensor to fix it.

Yes, I believe the hardware designers know how buggy this is...but
it's still worth some effort to fix the software as well as possible
for current hardware behavior.

> For now, let's first try removing ahci_start_engine() call from
> port_start and see how that goes.

Thanks for the help, and happy testing!

Brian
