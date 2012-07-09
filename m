Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2GILao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:30:44 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:34324 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab2GILan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:30:43 -0400
Date: Mon, 9 Jul 2012 14:30:40 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Dave Airlie <airlied@gmail.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: 3.5-rc5: radeon acceleration regression on Transmeta system
In-Reply-To: <alpine.SOC.1.00.1207052224340.19147@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1207090051120.3699@math.ut.ee>
References: <alpine.SOC.1.00.1207050956300.515@math.ut.ee> <CAPM=9tyo69+8QTCKMDCOTzWT2gR+uXkynOny85PaQ_nCYNMGAg@mail.gmail.com> <alpine.SOC.1.00.1207052224340.19147@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > In 3.4, radeon worked with a glitch - window titles were see-throug (not
> > > drawn). In 3.5-rc5, radeon driver seems to be more careful and disables
> > > acceleration on this system at all. Full dmesg below.
> > 
> > Does it always do it the same? got the dmesg from 3.4 and/or 2.6.32?
> 
> That was a good question. I did some more tries, and it was not 
> repeatable. Sometimes it worked like 3.4 did - rv100 initialized fine, 
> no borders except when maximized, otherwise worked.

Re-tested 3.4.0-rc7 that I had availble from 3.4 times, it worked 4 out 
of 4 times.

> Initial windows border problem seems to have been introduced between 
> 2.6.37 and 2.6.38, bisect is slow.

It's actually more complicated than that. Old kernel images started 
misbehaving from around 2.6.35-rc5 and any kernel older than that was 
OK. When I recompiled the older kernels with squeeze gcc (migh have been 
lenny gcc before, or different answers to make oldconfig), anything from 
current git down to 2.6.33 is broken with radeon.modeset=1 and works (I 
get window titles) with radeon.modeset=0.

2.6.32 works and has kernel modesetting enabled from dmesg but I think I 
did not notice screen going fbcon during boot... maybe it only used the 
modesetting when X started.

So there are 2 different problems (maybe related), the new one above and 
the old one of not seeing some window borders when modesetting and 
acceleration are in use. Maximized windows do have borders.

-- 
Meelis Roos (mroos@linux.ee)
