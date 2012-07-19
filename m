Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab2GSJXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:23:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:32795 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab2GSJW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:22:59 -0400
Date: Thu, 19 Jul 2012 10:22:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Allow CLOCK_TICK_RATE to be undefined
Message-ID: <20120719092239.GB28942@arm.com>
References: <1342543300-23460-1-git-send-email-catalin.marinas@arm.com>
 <20120718155141.232ae14c.akpm@linux-foundation.org>
 <50074287.3080802@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50074287.3080802@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 12:11:03AM +0100, John Stultz wrote:
> On 07/18/2012 03:51 PM, Andrew Morton wrote:
> > On Tue, 17 Jul 2012 17:41:40 +0100
> > Catalin Marinas <catalin.marinas@arm.com> wrote:
> >
> >> This patch allows an architecture to not define CLOCK_TICK_RATE, in
> >> which case ACTHZ defaults to (HZ << 8).
> > No reason was given for this change.
> >
> > So those people who are wondering "why don't you just define
> > CLOCK_TICK_RATE" are made all sad.
> 
> I just queued this patch with a revised commit message:
> 
>      jiffies: Allow CLOCK_TICK_RATE to be undefined
> 
>      CLOCK_TICK_RATE is a legacy constant that defines the timer
>      device's granularity. On hardware with particularly coarse
>      granularity, this constant is used to reduce accumulated
>      time error when using jiffies as a clocksource, by calculating
>      the hardware's actual tick length rather then just assuming
>      it is 1sec/HZ.
> 
>      However, for the most part this is unnecessary, as most modern
>      systems don't use jiffies for their clocksource, and their
>      tick device is sufficiently fine grained to avoid major error.
> 
>      Thus, this patch allows an architecture to not define
>      CLOCK_TICK_RATE, in which case ACTHZ defaults to (HZ << 8).
> 
> 
> Let me know if you'd like to see further improvements.

Looks good. Thanks for picking this up.

-- 
Catalin
