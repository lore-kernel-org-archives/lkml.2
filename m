Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab2AFUPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:15:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38290 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759026Ab2AFUPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:15:23 -0500
Date: Fri, 6 Jan 2012 12:15:01 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Frank Mandarino <fmandarino@endrelia.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Russell King <linux@arm.linux.org.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: Public ridicule due to sound/soc/soc-core.c abuse of the driver
 model
Message-ID: <20120106201458.GF2893@opensource.wolfsonmicro.com>
References: <20120106194052.GA7781@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106194052.GA7781@kroah.com>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 11:40:52AM -0800, Greg KH wrote:

> It was recently pointed out to me that the sound/soc/soc-core.c is
> flagrantly abusing the driver model by providing "empty" release
> functions, just to keep the kernel from complaining:

> Come on people, do you think that I wrote the code in the kernel that
> produces those errors just for fun?  It was telling you to fix your code
> by providing a function to free the structure that is being released,
> not to try to trick the kernel because you think you know better.  The
> kernel was trying to help you out here, to get the programming model
> correct, in a place that was commonly misunderstood.

The problem is that due to the entertaining nature of AC'97 support in
Linux we don't actually have anything to free at this point - we'd need
to redo the whole infrastructure, not just this code.

You really need to find someone with an ongoing interest in AC'97 and
convince them that it's worth overhauling the bus, the whole thing is
just too much of a can of worms to touch.  Fixing this for 3.3 seems
completely insane, we're already in the merge window and there's too
many skeletons.

I'm not even sure I have any AC'97 hardware any more myself.
