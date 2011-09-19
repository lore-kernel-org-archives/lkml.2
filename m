Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab1ISGdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 02:33:43 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:39366 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584Ab1ISGdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 02:33:41 -0400
Subject: Re: Proposal for a low-level Linux display framework
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Keith Packard <keithp@keithp.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-dev@lists.linaro.org, "Clark, Rob" <rob@ti.com>,
        Archit Taneja <archit@ti.com>
In-Reply-To: <20110916175326.54567b14@lxorguk.ukuu.org.uk>
References: <1316088425.11294.78.camel@lappyti>
	 <yunboul7sx7.fsf@aiko.keithp.com> <1316100594.23214.65.camel@deskari>
	 <yun8vpp7qk7.fsf@aiko.keithp.com> <1316107275.23214.99.camel@deskari>
	 <yunfwjxwbjq.fsf@aiko.keithp.com>
	 <20110916175326.54567b14@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 09:33:34 +0300
Message-ID: <1316414014.1978.12.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 17:53 +0100, Alan Cox wrote:
> > I'm not sure a common interface to all of these different
> > channels makes sense, but surely a DSI library and an aux channel
> > library would fit nicely alongside the existing DDC library.
> 
> DSI and the various other MIPI bits tend to be horribly panel and device
> specific. In one sense yes its a standard with standard commands,
> processes, queries etc, on the other a lot of stuff is oriented around
> the 'its a fixed configuration unit we don't need to have queries' view.

I think it's a bit more complex than that. True, there are MIPI
standards, for the video there are DPI, DBI, DSI, and for the commands
there is DCS. And, as you mentioned, many panels need custom
initialization, or support only parts of the DCS, or have other quirks.

However, I think the biggest thing to realize here is that DSI
peripherals can be anything. It's not always so that you have a DSI bus
and a single panel connected to it. You can have hubs, buffer chips,
etc.

We need DSI peripheral device drivers for those, a single "DSI output"
driver cannot work. And this is also the most important thing in my
original proposition.

> There also tends to be a lot of vendor magic initialisation logic both
> chipset and device dependant, and often 'plumbing dependant' on SoC

While I have DSI experience with only one SoC, I do believe it'd be
possible to create a DSI API that would allow us to have platform
independent DSI peripheral drivers.

Can you share any SoC side DSI peculiarities on Intel's SoCs?

 Tomi


