Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab0IOKxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:53:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37771 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0IOKxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:53:06 -0400
Date: Wed, 15 Sep 2010 13:52:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, Ming Lei <tom.leiming@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RESEND/PATCH 5/6] USB: musb-gadget: complete request only if
 data is transfered over
Message-ID: <20100915105251.GN3393@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20100915065345.GC3393@legolas.emea.dhcp.ti.com>
 <4C909961.10001@ru.mvista.com>
 <20100915100553.GJ3393@legolas.emea.dhcp.ti.com>
 <4C909B2E.3000909@ru.mvista.com>
 <AANLkTi=A+1ThrRTNjWoFbXr-G1OUnpThEwG5rCgGirzC@mail.gmail.com>
 <4C909D87.2090901@ru.mvista.com>
 <20100915102256.GK3393@legolas.emea.dhcp.ti.com>
 <4C909F99.9050300@mvista.com>
 <20100915103152.GM3393@legolas.emea.dhcp.ti.com>
 <4C90A2E3.9020300@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4C90A2E3.9020300@mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 15, 2010 at 05:41:39AM -0500, Sergei Shtylyov wrote:
>> your forgetting the fact that not always you need to send ZLP after
>> completing a packet_size-aligned transfer,
>
>    So what?

what you're saying is that when we change the ZLP handling, the
request->actual == request->lenght check will have to be removed, but
that's not true because ZLP is only needed if request->zero is set.

So the final code would be something like (pseudo-code):

if (request->lenght % musb_ep->packet_sz)
	set_last_packet_is_short_flag(musb_request);

if (request->zero || last_packet_is_short(request)) {
	set_txpktrdy(musb);
	set_musb_request_completed_flag(musb_request);
	return;
}

if (request->acual == request->length)
	musb_g_giveback(musb, request);

restart_ep_if_more_requests(musb_ep);


> > ok, but I don't.
>
>    Well, you're the maintainer.

the thing is that this discussion is preventing me from sending me the
other 10 patches to Greg. So either we drop it now and send the exact
same patch (or a similar version) for next -rc or I send them all now.
Since I'm not seeing the problem you're describing I'm more inclined to
send them all.

-- 
balbi
