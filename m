Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2EVNjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:39:13 -0400
Received: from flusers.ccur.com ([173.221.59.2]:45420 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752184Ab2EVNjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:39:11 -0400
Date: Tue, 22 May 2012 09:38:58 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "stasn77@gmail.com" <stasn77@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] port jRCU from 3.3 to 3.4
Message-ID: <20120522133858.GA17487@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20120521184528.GA4145@tsunami.ccur.com>
 <m2vcjp87mf.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2vcjp87mf.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 06:57:44PM -0400, Andi Kleen wrote:
> Joe Korty <joe.korty@ccur.com> writes:
> > + *
> > + * jRCU assumes that the frames are large enough that architecture barrier
> > + * operations performed in one frame have fully completed by the start of
> > + * the next.  This period is presumed to be in the tens of microseconds, so
> > + * it may not be wise to run jRCU at a frame rate under 100 usecs.
> 
> This sounds like a very dangerous assumption.

Yeah, I may have to go to a spin lock.  Easy to do, but
I didn't want the serialization that results.  I figured
that with a frame rate of 20 - 1000 Hz it wasn't necessary.

And of course I may not have fully understood all the
nuances of barriers and the memory model.  After all,
spin locks work using pretty much the same techniques and
they don't suffer from any need to delay.

Joe
