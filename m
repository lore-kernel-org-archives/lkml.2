Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2JBW27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:28:59 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49903 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2JBW25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <506B69B0.2010109@am.sony.com>
References: <506B69B0.2010109@am.sony.com>
Date: Tue, 2 Oct 2012 17:28:54 -0500
Message-ID: <CAOCHtYjLFE0aXL_ReZSdQZFJDPRW3Cx3vk4WEo9DU4g8QiF=gg@mail.gmail.com>
Subject: Re: Problem with mmc DMA on panda board in 3.6
From: Robert Nelson <robertcnelson@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 5:24 PM, Tim Bird <tim.bird@am.sony.com> wrote:
> This is an early report - I'm just checking if anyone else has seen this.
>
> With Linux version v3.6, my PandaBoard (OMAP-based) no longer boots.  The
> system appears to fail to initialize the mmc controller.
>
> The kernel log message of interest appears to be this:
> [    1.690002] omap_hsmmc omap_hsmmc.0: unable to obtain RX DMA engine channel 6
>
> I can supply full kernel log messages and my .config if needed.
>
> I bisected the code and arrived at the following commit:
> -------
> commit 26b88520b80695a6fa5fd95b5d97c03f4daf87e0
> Author: Russell King <rmk+kernel@arm.linux.org.uk>
> Date:   Fri Apr 13 12:27:37 2012 +0100
>
>     mmc: omap_hsmmc: remove private DMA API implementation
>
>     Remove the private DMA API implementation from omap_hsmmc, making it
>     use entirely the DMA engine API.
>
>     Tested-by: Tony Lindgren <tony@atomide.com>
>     Tested-by: Venkatraman S <svenkatr@ti.com>
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> -------
> The board works up until this commit.
> After this commit, the board hangs during boot after the message:
> [    1.852508] Waiting for root device /dev/mmcblk0p3...
> (and some other USB and network messages, which I presume
> are unrelated.)
>
> My questions are these:
> Has anyone else had problems with the PandaBoard (or other OMAP) on 3.6?
> Are there any related CONFIG_ variables I could change to try alternatives?
> What should I try next to debug this?

Check your config, to see if these are enabled:

CONFIG_DMADEVICES=y
CONFIG_DMA_OMAP=y

Regards,

-- 
Robert Nelson
http://www.rcn-ee.com/
