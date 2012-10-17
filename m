Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2JQI1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:27:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2JQI1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:27:38 -0400
Date: Wed, 17 Oct 2012 10:27:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [Q] reprobe deferred-probing drivers
Message-ID: <Pine.LNX.4.64.1210171021060.7402@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:muqaRf27SaVeu/ribnaeZfQhXcLeyPQj4omhKGMv2j1
 +/plFSAZpvrE8Q21Jj/VvvmQi1LLQsm3W0z0XHK1KX5+jsjRhy
 Uvd2WPiMxXC5gO2Pdq5cBgSSCwfHf4p+Yi0biJNw1KM1Tdh74R
 jA95io3I4FEF/SfQo8hCfqMGu3XrFGYfEWHIOO1tGuiZPf6YuG
 cHfWtNN/98uqbhKkIBs4eRkF5vMqVkOoqaZnX+eZPN13Xx/VUP
 NA2P4zWRPd9TZl4vtxqkdjrN5xl0UtEtz7jDzzT/kxyl85/o8H
 OwiGJ/JxiaUOTusCJWK+3+3YygjvZvYia5o4vzR2BAqxQM+NHh
 HacipCLYXOYviCspFMw9uflOcVLlG2PFrrGfEgFaQYq2FvAHMF
 x6AfDezQ+29Ew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've got a situation, for which I currently don't have a (good) solution.

Let's say device A depends on device B and as long as B hasn't probed, A 
requests deferred probing. Now B probes, which causes A to also succeed 
its probing. Next we want to remove B, say, by unloading its driver. A has 
to go back into "deferred-probing" state. How do we do it? This can be 
achieved by unloading B's driver and loading again. Essentially, we have 
to use the sysfs "unbind" and then the "bind" attributes. But how do we do 
this from the kernel? Shall we export driver_bind() and driver_unbind()?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
