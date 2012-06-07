Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476Ab2FGCFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:05:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759447Ab2FGCFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:05:44 -0400
Date: Thu, 7 Jun 2012 04:05:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
In-Reply-To: <4FBD01A6.4080807@wwwdotorg.org>
Message-ID: <Pine.LNX.4.64.1206070332100.9501@axis700.grange>
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange>
 <4FBCF9F0.1010901@wwwdotorg.org> <Pine.LNX.4.64.1205231659310.21980@axis700.grange>
 <4FBD01A6.4080807@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:7iHQcfcfKqX0/NcyuJxISUg0M4UIHzVKVMI2Rg/bX4f
 mVt5DgqbP98a3DFjIlKo76/olJRzua3EZ9RO0xhvaFpEYDbdDM
 zD6TJjdIoB6GHWhKaIcR2Q02ALrQvFV+V+Xk8NO56rqG6OTqEO
 CJC3fUPyGcYbaT2IAU9cs4HyjtNm6oW6l6FXRzgQjuvwSCi5TX
 modCeu9luwq2LxrS98YXRwJ0Fm+U/nWyc4JBeFvGJcanWbLZV+
 oAFLgZd0iNpqqyOtGtXrO3LxH3yP68eRbqH62IGi70biXy2Vh9
 JZvS140nUpi7WXJPd6mN5V0qaCbwPn1CfYZN4p6FGRwCVHqYN/
 8R29wMIdvamgJxjriD2QNIOh2EglYNgE2P2YVUF+UKt5jYe4PJ
 gQv7IVMLq4/rw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen

Thanks for your comments and sorry for a delay.

On Wed, 23 May 2012, Stephen Warren wrote:

> On 05/23/2012 09:03 AM, Guennadi Liakhovetski wrote:
> > On Wed, 23 May 2012, Stephen Warren wrote:
> > 
> >> On 05/22/2012 04:23 PM, Guennadi Liakhovetski wrote:
> >>> This patch adds a new function to allow clients to verify, whether a
> >>> certain group is selected in the currently active setting or not.
> >>>
> >>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >>> ---
> >>>
> >>> Maybe there is already a way to do this without adding a new function, I 
> >>> haven't found one, hence this patch.
> >>
> >> This function doesn't currently exist because it breaks the pinctrl
> >> conceptual model, which is that devices ask pinctrl for certain settings
> >> whenever they need them, rather than information flowing the other way.
> > 
> > Well, yes, we could tra to ask for each thinkable configuration and see 
> > which one(s) succeed, but that doesn't seem very optimal either, even if 
> > we only have 3 possibilities for now.
> > 
> >> What's the use case for this new functionality?
> > 
> > It's MMC. MMC interfaces can use 1, 4, or 8 data lines, depending on the 
> > board configuration. The board knows, that it has, say, only 4 data lines 
> > routed to the interface, so, it specifies the respective pinctrl 
> > configuration as default. Now in the driver we have to know how many 
> > data-lines are connected.
> 
> If using device tree, the bus-width property should be used. If not
> using device tree, presumably you'd add an equivalent field to the
> platform data.

Wouldn't adding a bus-width field to the platform data be redundant, 
considering it's already available in the pinctrl configuration?

> An alternative (only when not using DT, since there's already a property
> for DT) is that the driver doesn't select pinctrl state "default", but
> instead first looks for e.g. "8bit" and if found uses it, then falls
> back to "4bit", then falls back to "1bit". Whichever state name is
> defined indicates which bus width is available.

Sorry for not mentioning this in my previous reply, but there's more to 
it, not just data lines can optionally be present. Each of the 3 possible 
data-bus widths can also have Card Detection and Write Protect lines 
present, which brings the number of possible configurations to 4 * 3 = 
12... We don't want to try all of them, right? Whereas just querying the 
pinctrl framework about which pins have been selected and configured seems 
to be quite straight forward to me. Or should we request several 
configurations from the driver? One of the 3 bus widthes, and additionally 
a card-detection and a write-protect configurations?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
