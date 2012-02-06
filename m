Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2BFIxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:53:10 -0500
Received: from relmlor4.renesas.com ([210.160.252.174]:35030 "EHLO
	relmlor4.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2BFIxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 03:53:07 -0500
X-IronPort-AV: E=Sophos;i="4.73,369,1325430000";   d="scan'208";a="66780133"
Message-id: <4F2F94D1.1080308@renesas.com>
Date: Mon, 06 Feb 2012 17:52:33 +0900
From: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0) Gecko/20120129
 Thunderbird/10.0
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH/RFC] usb: fix renesas_usbhs to not schedule in atomic
 context
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
 <4F22624E.2090201@renesas.com>
 <Pine.LNX.4.64.1201270946150.32661@axis700.grange> <4F27CA7D.601@renesas.com>
 <Pine.LNX.4.64.1202022317560.13860@axis700.grange>
 <4F2B9F34.60308@renesas.com> <Pine.LNX.4.64.1202031623000.6211@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1202031623000.6211@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi-san,

2012/02/04 0:43, Guennadi Liakhovetski wrote:
> The current renesas_usbhs driver triggers
> 
> BUG: scheduling while atomic: ksoftirqd/0/3/0x00000102
> 
> with enabled CONFIG_DEBUG_ATOMIC_SLEEP, by submitting DMA transfers from 
> an atomic (tasklet) context, which is not supported by the shdma dmaengine 
> driver. Fix it by switching to a work. Also simplify some list 
> manipulations.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Shimoda-san, this is the problem, that you were observing. However, it 
> exists with the present version of shdma just as well as with the new one 
> - on top of the simple DMA library. I marked it an RFC because (1) I only 
> lightly tested it with the gadget device on mackerel with the mass storage 
> gadget, and (2) I am somewhat concerned about races. Currently the work 
> function runs with no locking and there are no usual cancel_work_sync() 
> points in the patch. However, it has also been like this before with the 
> tasklet implementation, which is not much better, and it looks like there 
> are no asynchronous operations on the same packets like timeouts. Only 
> asynchronous events, that I can think about are things like unloading the 
> driver or unplugging the cable, but these have been there before too. It 
> would become worse on SMP, I think. Comments welcome.

Thank you for the patch and comments.
I also tested this patch using the g_mass_storage and g_ether.
About your points, I think so, too.
So, I will write such a code.

Best regards,
Yoshihiro Shimoda
