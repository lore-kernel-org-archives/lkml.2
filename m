Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab1HWVuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:50:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32860 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625Ab1HWVuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:50:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Date: Tue, 23 Aug 2011 23:51:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20110823151936.GM9232@opensource.wolfsonmicro.com>
In-Reply-To: <20110823151936.GM9232@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108232351.55432.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 23, 2011, Mark Brown wrote:
> The recent series of commits reworking the freezer appear to have
> caused serious issues on ARM.  The kernel constantly complains that
> try_to_freeze() is bring called with interrupts disabled:
> 
> [   75.380000] BUG: sleeping function called from invalid context at include/linux/freezer.h:44
> [   75.380000] in_atomic(): 0, irqs_disabled(): 128, pid: 1517, name: Xorg
> [   75.380000] no locks held by Xorg/1517.
> [   75.380000] [<c0014308>] (unwind_backtrace+0x0/0x12c) from
> [<c0464400>] (dump_stack+0x20/0x24)
> [   75.380000] [<c0464400>] (dump_stack+0x20/0x24) from [<c0022b80>]
> (__might_sleep+0xfc/0x11c)
> [   75.380000] [<c0022b80>] (__might_sleep+0xfc/0x11c) from [<c0011520>]
> (do_signal+0x94/0x230)
> [   75.380000] [<c0011520>] (do_signal+0x94/0x230) from [<c00116e4>]
> (do_notify_resume+0x28/0x6c)
> [   75.380000] [<c00116e4>] (do_notify_resume+0x28/0x6c) from
> [<c000eaf8>] (work_pending+0x24/0x28)
> 
> and the boot runs very slowly.  Reverting the series merged in 56f0be
> appears to resolve the issue,

In fact, the patch from:

https://patchwork.kernel.org/patch/1083602/

is sufficient to make the calltrace go away.
