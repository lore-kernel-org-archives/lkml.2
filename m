Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619Ab2EWPDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:03:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55976 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab2EWPDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:03:40 -0400
Date: Wed, 23 May 2012 17:03:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Stephen Warren <swarren@wwwdotorg.org>
cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
In-Reply-To: <4FBCF9F0.1010901@wwwdotorg.org>
Message-ID: <Pine.LNX.4.64.1205231659310.21980@axis700.grange>
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange>
 <4FBCF9F0.1010901@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:L9vEzoRL+6KpT7qBK5anfXGUEIQO1So3XTP0bC4A78N
 eyfXh3oyDYBppl0VgSkRkO7ooG8wmH+Muxcygc9GqHgwvjW/GH
 Xg2WuJ3DnkVdHHziYOaHgUy39LWLaHIpc1Ru6IBF/NoEE6SLGc
 +a5E3Z34gaQ0miEIrdoFdBQmCOJG6YpKoFPOR30H/SkqJTg8AB
 OXew8v6wvYGlYQZqgIUYZSQcFRv+6/nci+DgmzEp6AEwu1mug/
 sCeEVe0TG7VeNmqHGw3yi3f8qVZCwQSoR4ORi3Ajr2F/QFkBdx
 FtAcJa1xo+kpjbkFR3Al+fIlU84NHp2BPGS+qhpp64XJsWfewa
 9xewbDzsgnm0jlaWN/mqd21Yse9d6YdJPzm86m9P9zXhKHeRyP
 R6QzlpwyaKcPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Stephen Warren wrote:

> On 05/22/2012 04:23 PM, Guennadi Liakhovetski wrote:
> > This patch adds a new function to allow clients to verify, whether a
> > certain group is selected in the currently active setting or not.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > Maybe there is already a way to do this without adding a new function, I 
> > haven't found one, hence this patch.
> 
> This function doesn't currently exist because it breaks the pinctrl
> conceptual model, which is that devices ask pinctrl for certain settings
> whenever they need them, rather than information flowing the other way.

Well, yes, we could tra to ask for each thinkable configuration and see 
which one(s) succeed, but that doesn't seem very optimal either, even if 
we only have 3 possibilities for now.

> What's the use case for this new functionality?

It's MMC. MMC interfaces can use 1, 4, or 8 data lines, depending on the 
board configuration. The board knows, that it has, say, only 4 data lines 
routed to the interface, so, it specifies the respective pinctrl 
configuration as default. Now in the driver we have to know how many 
data-lines are connected.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
