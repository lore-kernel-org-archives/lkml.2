Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0CRRzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:55:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56487 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab0CRRzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:55:48 -0400
Subject: Re: [RFC][PATCH] Convert alpha to use clocksource
From: john stultz <johnstul@us.ibm.com>
To: Richard Henderson <rth@twiddle.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>
In-Reply-To: <4BA23974.5030503@twiddle.net>
References: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com>
	 <4BA23974.5030503@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 10:55:23 -0700
Message-ID: <1268934923.1855.8.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 07:32 -0700, Richard Henderson wrote:
> On 03/17/2010 07:01 PM, John Stultz wrote:
> > Alpha has a tsc like rpcc counter that it uses to manage time.
> > This can be converted to an actual clocksource instead of utilizing
> > the arch_gettimeoffset method that is really only there for legacy
> > systems with no continuous counter.
> 
> With 8 seconds or less between roll-overs, do you actually consider
> this a continuous counter?  I don't.  I suggest this be left alone.

The timekeeping code handles this (although the shift value I picked may
need some adjustment - what is the expected counter freq range on
alpha?). The ACPI PM counter which is very common on x86 is only 24 bits
and rolls over in ~5 seconds. It works fine.

However, I'm not maintaining the arch, and this patch isn't limiting the
timekeeping core, so the call is really yours. I sent this out on a whim
since it looked easy to do.

However, while this change is totally optional, I suspect my suggestion
about moving to the clockevents code is going to rise in importance. The
triplicate timer code paths of non-converted, converted periodic and
converted one-shot is difficult to follow.

I'll try to find a good example of an easy conversion case (PIT on x86
is not it) and send it your way.

thanks
-john


