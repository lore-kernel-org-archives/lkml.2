Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934791Ab0E0S7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:59:17 -0400
Received: from www.tglx.de ([62.245.132.106]:40517 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759533Ab0E0S7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:59:16 -0400
Date: Thu, 27 May 2010 20:58:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1005272056530.3032@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org> <1274982779.27810.5708.camel@twins> <20100527175719.GD3543@srcf.ucam.org> <1274983333.27810.5744.camel@twins> <20100527181433.GG3543@srcf.ucam.org>
 <20100527200313.5c532f2f@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alan Cox wrote:

> > No, it's not. Forced suspend may be in response to hitting a key, but it 
> 
> You are the only person here talking about 'forced' suspends. The rest of
> us are talking about idling down and ensuring we are always in a state we
> un-idle correctly.
> 
> > may also be in response to a 30 minute timeout expiring. If I get a WoL 
> > packet in the 0.5 of a second between userspace deciding to suspend and 
> > actually doing so, the system shouldn't suspend.
> 
> I don't think that argument holds water in the form you have it
> 
> What about 5 nanoseconds before you suspend. Now you can't do that (laws
> of physics and stuff).
> 
> So your position would seem to be "we have a race but can debate how big
> is permissible"
> 
> The usual model is
> 
> "At no point should we be in a position when entering a suspend style
>  deep sleep where we neither abort the suspend, nor commit to a
>  suspend/resume sequence if the events we care about occur"
> 
> and that is why the hardware model is
> 
> 	Set wake flags
> 	Check if idle
> 	If idle
> 		Suspend
> 	else
> 		Clear wake flags
> 		Unwind
> 
> and the wake flags guarantee that an event at any point after the wake
> flags are set until they are cleared will cause a suspend to be resumed,
> possibly immediately after the suspend.

And if a platform can not guarantee the wakeup or the lossless
transition of states then you can not solve this by throwing blockers
or whatever into the code.

Thanks,

	tglx
