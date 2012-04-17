Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2DQHPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:15:53 -0400
Received: from metasoft.pl ([195.149.224.191]:34400 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2DQHPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:15:52 -0400
X-clamdmail: clamdmail 0.18a
Message-ID: <4F8D189B.3010100@metasoft.pl>
Date: Tue, 17 Apr 2012 09:15:39 +0200
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Mika Westerberg <mika.westerberg@iki.fi>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
References: <4F683B36.8090101@metasoft.pl> <20120321193836.GC3740@mwesterb-mobl.ger.corp.intel.com> <ADE657CA350FB648AAC2C43247A983F0020696D48E3E@AUSP01VMBX24.collaborationhost.net> <20120323070446.GC5812@mwesterb-mobl.ger.corp.intel.com> <ADE657CA350FB648AAC2C43247A983F0020696D48EEB@AUSP01VMBX24.collaborationhost.net> <20120410172853.GA25697@mwesterb-mobl> <ADE657CA350FB648AAC2C43247A983F00206986C01D4@AUSP01VMBX24.collaborationhost.net> <4F853053.7040800@metasoft.pl> <ADE657CA350FB648AAC2C43247A983F00206987A3BFE@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206987A3BFE@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-16 20:59, H Hartley Sweeten wrote:
> On Wednesday, April 11, 2012 12:19 AM, Rafal Prylowski wrote:
> 
> Rafal,
> 
> This patch still doesn't work on my ep93xx system.

<snip>

> It appears your patch is causing an interrupt storm on my system.
> 

Could you please apply the following patch on top of double buffering
patch? I would like to know the state of dma channel when you get
that interrupt storm.

Thanks,
RP

Index: linux-2.6/drivers/dma/ep93xx_dma.c
===================================================================
--- linux-2.6.orig/drivers/dma/ep93xx_dma.c
+++ linux-2.6/drivers/dma/ep93xx_dma.c
@@ -606,6 +606,7 @@ static int m2m_hw_interrupt(struct ep93x
 	 */
 	last = list_first_entry(edmac->active.next,
 		struct ep93xx_dma_desc, node)->txd.cookie;
+	printk("M2M: %x %s\n", status, last ? "last" : "");
 
 	/*
 	 * Use M2M DMA Buffer FSM and Control FSM to check current state of
