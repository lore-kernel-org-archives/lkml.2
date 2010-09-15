Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0IONDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:03:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45368 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab0IONDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:03:33 -0400
Message-ID: <4C90C3F5.2020202@ru.mvista.com>
Date: Wed, 15 Sep 2010 17:02:45 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: balbi@ti.com
CC: Sergei Shtylyov <sshtylyov@mvista.com>, Ming Lei <tom.leiming@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
References: <20100915065345.GC3393@legolas.emea.dhcp.ti.com> <4C909961.10001@ru.mvista.com> <20100915100553.GJ3393@legolas.emea.dhcp.ti.com> <4C909B2E.3000909@ru.mvista.com> <AANLkTi=A+1ThrRTNjWoFbXr-G1OUnpThEwG5rCgGirzC@mail.gmail.com> <4C909D87.2090901@ru.mvista.com> <20100915102256.GK3393@legolas.emea.dhcp.ti.com> <4C909F99.9050300@mvista.com> <20100915103152.GM3393@legolas.emea.dhcp.ti.com> <4C90A2E3.9020300@mvista.com> <20100915105251.GN3393@legolas.emea.dhcp.ti.com>
In-Reply-To: <20100915105251.GN3393@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:

>>> your forgetting the fact that not always you need to send ZLP after
>>> completing a packet_size-aligned transfer,

>>    So what?

> what you're saying is that when we change the ZLP handling, the
> request->actual == request->lenght check will have to be removed, but
> that's not true because ZLP is only needed if request->zero is set.

> So the final code would be something like (pseudo-code):

> if (request->lenght % musb_ep->packet_sz)
>     set_last_packet_is_short_flag(musb_request);

> if (request->zero || last_packet_is_short(request)) {
>     set_txpktrdy(musb);
>     set_musb_request_completed_flag(musb_request);
>     return;
> }

> if (request->acual == request->length)
>     musb_g_giveback(musb, request);

> restart_ep_if_more_requests(musb_ep);

    No, this code will still send ZLP before the whole requested transfer is 
done. The (request->actual == request->length) check is needed before we even 
check that request->zero is set (and it is there but not for the DMA case). I 
thought that this was quite obvious, and I was surprised that this caused such a 
lengthy discussion.

WBR, Sergei
