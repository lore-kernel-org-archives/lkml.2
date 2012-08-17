Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2HQLjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:39:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:49480 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2HQLjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:39:24 -0400
Message-ID: <502E2D69.3040302@linutronix.de>
Date: Fri, 17 Aug 2012 13:39:21 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de> <502D1CC2.9020901@antcom.de> <502E0A7B.1040607@antcom.de> <20120817105103.GE4651@arwen.pp.htv.fi> <502E2498.4090106@linutronix.de> <20120817110256.GG4651@arwen.pp.htv.fi> <502E2BD4.5090803@antcom.de>
In-Reply-To: <502E2BD4.5090803@antcom.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 01:32 PM, Roland Stigge wrote:
> How about the following: Below, I show how the initialization of the
> current controller is done (statically). Removing this struct
> initialization completely would make the code much uglier, introducing
> many individual assignments.

I said what I had to say, I leave it up to Felipe.

> static struct lpc32xx_udc controller = {
>          .gadget = {
>                  .ops    =&lpc32xx_udc_ops,
>                  .ep0    =&controller.ep[0].ep,
>                  .name   = driver_name,
>                  .dev    = {
>                          .init_name = "gadget",
>                          .release = nop_release,
>                  }
>          },
>          .ep[0] = {
>                  .ep = {
>                          .name   = "ep0",
>                          .ops    =&lpc32xx_ep_ops,
>                  },
>                  .udc            =&controller,
>                  .maxpacket      = 64,
>                  .hwep_num_base  = 0,
>                  .hwep_num       = 0, /* Can be 0 or 1, has special
> handling */

Can it be 0 or 1 or has it to be 0? Who would change and why?

>                  .lep            = 0,
>                  .eptype         = EP_CTL_TYPE,
>          },
>          .ep[1] = {
>                  .ep = {
>                          .name   = "ep1-int",
>                          .ops    =&lpc32xx_ep_ops,
>                  },
>                  .udc            =&controller,
>                  .maxpacket      = 64,
>                  .hwep_num_base  = 2,
>                  .hwep_num       = 0, /* 2 or 3, will be set later */

Why not now?

>                  .lep            = 1,
>                  .eptype         = EP_INT_TYPE,

Do you have any restrictions on these endpoints? I mean can you pick
any endpoints for BULK/INT/ISO or have they been pre-defined by HW?

Sebastian
