Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2JBWUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:20:07 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:2219
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874Ab2JBWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:20:05 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2fh2a8h668h839hd25hf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Message-ID: <506B69B0.2010109@am.sony.com>
Date: Tue, 2 Oct 2012 15:24:48 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, <svenkatr@ti.com>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Problem with mmc DMA on panda board in 3.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an early report - I'm just checking if anyone else has seen this.

With Linux version v3.6, my PandaBoard (OMAP-based) no longer boots.  The
system appears to fail to initialize the mmc controller.

The kernel log message of interest appears to be this:
[    1.690002] omap_hsmmc omap_hsmmc.0: unable to obtain RX DMA engine channel 6

I can supply full kernel log messages and my .config if needed.

I bisected the code and arrived at the following commit:
-------
commit 26b88520b80695a6fa5fd95b5d97c03f4daf87e0
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Fri Apr 13 12:27:37 2012 +0100

    mmc: omap_hsmmc: remove private DMA API implementation

    Remove the private DMA API implementation from omap_hsmmc, making it
    use entirely the DMA engine API.

    Tested-by: Tony Lindgren <tony@atomide.com>
    Tested-by: Venkatraman S <svenkatr@ti.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
-------
The board works up until this commit.
After this commit, the board hangs during boot after the message:
[    1.852508] Waiting for root device /dev/mmcblk0p3...
(and some other USB and network messages, which I presume
are unrelated.)

My questions are these:
Has anyone else had problems with the PandaBoard (or other OMAP) on 3.6?
Are there any related CONFIG_ variables I could change to try alternatives?
What should I try next to debug this?

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

