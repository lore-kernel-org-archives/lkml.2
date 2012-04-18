Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2DRROo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:14:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2DRROm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:14:42 -0400
Date: Wed, 18 Apr 2012 13:14:38 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120418171438.GA24290@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120417172142.GA30237@redhat.com>
 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com>
 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
 <20120418031935.GB29828@redhat.com>
 <CA+55aFwrARr4=ZztWseFbND1h6W=QV52r98qioL+bK6jKrehSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwrARr4=ZztWseFbND1h6W=QV52r98qioL+bK6jKrehSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 10:02:06AM -0700, Linus Torvalds wrote:

 > > the traces below, which look pretty.. deep.
 > 
 > Yeah. Sadly, they are less useful than I was hoping for. It's not some
 > single deep call-chain, it's almost all debug stuff and the "did we
 > release the RCU lock" or preemption checks, which I guess makes sense.
 > You have tons of options enabled in your kernel that makes for deeper
 > stack traces, and then all the interesting stuff gets overwritten by
 > what happened later.

One thing I'm curious about.. Some of the function names are repeated
for a reason that doesn't seem obvious to me, when the call chain doesn't
call them in a loop. What's that about ?

 > I assume you have USB serial console on for a reason (ie: great for
 > catching oopses before the machine dies), but in this case it hurts.

Yeah, there's a (possibly related) problem where once a day some oops
gets triggered that just wedges the machine. I've not managed to capture
it yet, and the most I've gotten over the usb console was about
a dozen characters before it hung.

I've disabled the console blanking, and hooked up a monitor to it.
Perhaps that'll be enough to capture it without resorting to usb console.

 > Could you try just adding a
 > 
 >    console_lock();
 >    ...
 >    console_unlock();
 > 
 > around the show_trace() call. That will force the code to not actually
 > call down to the console layer until after the console_unlock(), so
 > the printing of the stack trace won't affect the stack *too* much.

That's a neat trick. I'll add that, in case I do have to fall back to usb console.

thanks,

	Dave

