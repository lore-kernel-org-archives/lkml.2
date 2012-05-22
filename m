Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab2EVPYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:24:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42938 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2EVPYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:24:10 -0400
Date: Tue, 22 May 2012 17:24:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Korty <joe.korty@ccur.com>
Cc: Andi Kleen <andi@firstfloor.org>, "stasn77@gmail.com" <stasn77@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] port jRCU from 3.3 to 3.4
Message-ID: <20120522152404.GW27374@one.firstfloor.org>
References: <20120521184528.GA4145@tsunami.ccur.com> <m2vcjp87mf.fsf@firstfloor.org> <20120522133858.GA17487@tsunami.ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522133858.GA17487@tsunami.ccur.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 09:38:58AM -0400, Joe Korty wrote:
> On Mon, May 21, 2012 at 06:57:44PM -0400, Andi Kleen wrote:
> > Joe Korty <joe.korty@ccur.com> writes:
> > > + *
> > > + * jRCU assumes that the frames are large enough that architecture barrier
> > > + * operations performed in one frame have fully completed by the start of
> > > + * the next.  This period is presumed to be in the tens of microseconds, so
> > > + * it may not be wise to run jRCU at a frame rate under 100 usecs.
> > 
> > This sounds like a very dangerous assumption.
> 
> Yeah, I may have to go to a spin lock.  Easy to do, but
> I didn't want the serialization that results.  I figured
> that with a frame rate of 20 - 1000 Hz it wasn't necessary.

I think you have to. Relying on timing like this is just a ticking
time bomb.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
