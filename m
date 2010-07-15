Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab0GOH7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 03:59:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:54760 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932617Ab0GOH7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 03:59:12 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/TW8VHhQzTS2UkemXrXgdO9FdXDa8R0KPfJcs6nL
	rVgx1jb9E3Ke2c
Date: Thu, 15 Jul 2010 09:59:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Axel Lin <axel.lin@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 7/12] wm8940: fix resource reclaim in wm8940_register 
 error path
In-Reply-To: <AANLkTil_buBStfVy_L9iTgPrxosmSRFhNU1MbaXWJfMx@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1007150952340.5310@axis700.grange>
References: <1279162147.29294.2.camel@mola> <1279162893.29294.20.camel@mola>
  <Pine.LNX.4.64.1007150855200.5310@axis700.grange>
 <AANLkTil_buBStfVy_L9iTgPrxosmSRFhNU1MbaXWJfMx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Axel Lin wrote:

> I agree that it is good to release resources at the same level,
> where they have been acquired.
> But I prefer to follow the maintainer/author's coding style.

Yeah, unless that "style" is a bug. IMHO this design is just buggy, 
unmaintainable, error-prone, and unjustified.

> 
> For the changes in other drivers, I'd like to see Liam and Mark's comments.
> Or if the driver maintainers request it, I can fix it.

Well, as the author of sound/soc/codecs/wm8978.c, I'd be happy if you 
change it in this way;) And also move the

	kfree(wm8978);

line from wm8978_unregister() to wm8978_i2c_remove().

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
