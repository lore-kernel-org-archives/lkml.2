Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457Ab0ITU2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:28:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59843 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756705Ab0ITU2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:28:07 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18wjhM2Op0wXrFFVBCMaG8K5IXS+tR1K5tp9Nfq03
	Rx/1GMOiVyrlz0
Date: Mon, 20 Sep 2010 22:27:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
In-Reply-To: <20100920221424.04150239@neptune.home>
Message-ID: <Pine.LNX.4.64.1009202223450.19429@axis700.grange>
References: <20100919172833.14bf291e@neptune.home> <4C963E99.9080207@gmx.de>
 <20100919190240.65762511@neptune.home> <4C97B079.8050707@gmx.de>
 <Pine.LNX.4.64.1009202118110.19429@axis700.grange> <20100920221424.04150239@neptune.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Bruno Prémont wrote:

> On Mon, 20 September 2010 Guennadi Liakhovetski wrote:
> 
> > Of course, the optimal solution would be to design and implement a
> > mechanism to notify framebuffer users about a changed fb configuration,
> > but we're not that far yet...
> 
> This would include ABI change for userspace, hard to get it trough...
> (except maybe if userspace has to opt-in for the notification and kernel
> can thus differentiate the "old" and "new" users)

Yes, something like that...

> But how would you handle userspace apps that can't consume notifications right
> away? Do you timeout or risk long stalls?

In the same way as they're currently [1] handled: as long as there are 
active fb-users, I reconfigure the physical interface but preserve the 
user configuration, i.e., I either display the smaller user framebuffer on 
a part of the larger display or a part of the larger user framebuffer on 
the whole smaller display.

[1] http://thread.gmane.org/gmane.linux.ports.sh.devel/8751

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
