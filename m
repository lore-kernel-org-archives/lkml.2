Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096Ab2J2XQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2J2XQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:16:40 -0400
Message-ID: <1351552559.3810.2.camel@turiel>
Subject: Re: Nouveau regression between 3.6 and 3.7-rc3: driver stuck at
 "running init tables"
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 09:15:59 +1000
In-Reply-To: <20121029230647.GA10369@kashmir>
References: <20121029230647.GA10369@kashmir>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 00:06 +0100, Mathieu Chouquet-Stringer wrote:
> 	Hi Ben,
Hey Mathieu,

> 
> I haven't been able to boot any 3.7 kernels since there's a regression
> which freezes my machine hard (a lenovo t530 with the dreaded optimus
> thing).
> 
> 3.6 used to work but 3.7 get stuck at (copied by hand but I have an ugly
> screenshot if you'd like):
> nouveau [   VBIOS][0000:01:00.0] running init tables
Are you able to go back to the current master, and get me a
log/screenshot with "nouveau.debug=trace" appended to your kernel
options?

Thanks,
Ben.

> 
> Note my uefi settings weren't modified during the whole thing.
> 
> I've bisected the issue and git found that commit 4196fa is the one
> causing trouble (looking at the diff, it's pretty big):
> 
> Author: Ben Skeggs <bskeggs@redhat.com>
> Date:   Tue Jul 10 14:36:38 2012 +1000
> 
>     drm/nouveau/i2c: port to subdev interfaces
> 
>     v2/v3: Ben Skeggs <bskeggs@redhat.com>
>     - fix typo in default bus selection
>     - fix accidental loss of destructor
> 
>     v4: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
>     - fix typo causing incorrect default i2c port settings when no BMP data
> 
> While bisecting the matter, I had a couple of messages like the
> following (6 actually).  The addresses were always different (I could
> send another ugly screenshot if you'd like).
> 
> Condition still not met after 2000ms, skipping following opcodes
> 
> followed by:
> 
> Parsing VBIOUS init table 1 at offset 0x8183
> 
> At this point, the kernel was frozen hard (sysrq wasn't working)...
> 
> I'm attaching the output of lspci and my kernel config.
> 
> If you'd like me to add some debug statements or if you need more info,
> feel free, I'd love to help.
> 
> Cheers,
> 


