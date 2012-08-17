Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030895Ab2HQJmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:42:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:48840 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab2HQJmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:42:20 -0400
Message-ID: <502E11F7.4080300@linutronix.de>
Date: Fri, 17 Aug 2012 11:42:15 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>, balbi@ti.com
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, aletes.xgr@gmail.com,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop interface
References: <1345131276-28982-1-git-send-email-stigge@antcom.de> <502D1A49.20603@linutronix.de> <502D1CC2.9020901@antcom.de> <502E0A7B.1040607@antcom.de>
In-Reply-To: <502E0A7B.1040607@antcom.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 11:10 AM, Roland Stigge wrote:
> Also, since this device is a single controller in the LPC32xx SoC, I
> would keep it until some other silicon uses several of this IP core
> (which I doubt), at which point we would probably still keep the (global
> static) controller and memcpy it to a dynamically allocated struct.
>
> Sounds reasonable?

Yes it does.

Some minor things:
- please use to_udc() in start then
- would it make sense to use platform_get_drvdata() in
   lpc32xx_udc_shutdown() ?
- could you please remove struct usb_endpoint_descriptor from struct
   lpc32xx_ep? It has been removed a while back from other drivers.

Your proc_udc_show() makes me sad. Felipe, didn't we want something
like this in udc-core?

> Thanks,
>
> Roland

Sebastian
