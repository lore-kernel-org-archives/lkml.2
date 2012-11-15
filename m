Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423620Ab2KOKKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:10:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423250Ab2KOKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:10:11 -0500
Date: Thu, 15 Nov 2012 11:10:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [Q] regulators: 3-current-regulated supply
In-Reply-To: <20121115071838.GI7599@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1211151103540.684@axis700.grange>
References: <Pine.LNX.4.64.1211150749290.684@axis700.grange>
 <20121115071838.GI7599@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:n8u5DgfRbUseRa21FDCB2ar2A9dkYhZsrU1cxrrVBtq
 XeEA6egyktfaYOgPv3pcCs/Vc6USIFDul+n/XDlUEcR/rgD+m7
 /CzPS73rActUohkdgKDwqohf9si2af5EjIQGyw3esUgf3dqnLl
 Q63pixxJ89Dm69SaQfhpx3ld5VA1nf6Eo3UVP+MsfGaaNGtog6
 QPBEUL9EVto5Q3uZdyrlg7O2NbCyOQZx/Nejrv3lYctm0Os+b9
 dWu7iKmBqaTtLUWTCVwAiPTtMpsuYi9J1A5PnYR7I97Z6P5gTh
 YcNKOX9CXLH9i6Pt2/irCMEWJtr0GVBpLEAubAg4RF2pKE/hIo
 S6Ee2Jq+qpCThrRozWNXRUDivKxQwl7g6TTPciwtochCoqHiQd
 DVArT3ZvJVK2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark

On Thu, 15 Nov 2012, Mark Brown wrote:

> On Thu, Nov 15, 2012 at 08:15:15AM +0100, Guennadi Liakhovetski wrote:
> 
> > parts are pretty simple - DCDC step-down, LDO. The first step-up DCDC 
> > isn't a problem either. It's the second step-up supply, that I'm having a 
> > problem with. It's output voltage can be regulated by using either a 
> > voltage feedback or the three current feedbacks. In the current feedback 
> > mode one has a choice between a manual mode, in which case you just choose 
> > one of the feedbacks and everything is simple again, or in automatic mode. 
> 
> This almost certainly has no other function than to drive a LED string
> for a backlight; it's not sensible to represent it via the regulator
> framework at all.  Just implement it as a backlight and/or LED driver
> and have done with it unless you can find some other use for it.

Hm, interesting. In my case it is of course a backlight power source, but 
wouldn't it be too limiting to also implement it as a backlight driver? I 
guess I will do that, I'm not too interested in implementing something 
hugely generic, for which I have no use either, just wondering... So, I 
would be hiding all the flexibility in this case in platform data, 
including the selection of the feedback method (voltage vs. current), 
overvoltage protection and pins used... I guess, I'll just begin with 
implementing just one mode, the one used on my board and see if any other 
modes are ever needed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
