Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0H0LYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:24:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59371 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab0H0LYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PHtOboy/6hhMjnzmc8VpYDsOzmvxI+lPzBbC6liAQczVceM74lv/HNtVses+WapAqr
         Zbn9Y8jUmO6lAGCbe8k8eg+56QADueguQu6+N6Tg44rCLC9vcvHBp2Zeso86UeZK4t/X
         jwHMW2TMjzM5CAA65x+NSfwm+MBNFTwSrkkn8=
Date: Fri, 27 Aug 2010 13:24:06 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] posix clocks: introduce syscall for clock tuning.
Message-ID: <20100827112406.GB11657@riccoc20.at.omicron.at>
References: <cover.1282550649.git.richard.cochran@omicron.at>
 <e253843e07ce5d15c2c8d11ce786bf979ed85ca5.1282550649.git.richard.cochran@omicron.at>
 <201008231457.26690.arnd@arndb.de>
 <1282596073.3111.373.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282596073.3111.373.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 01:41:13PM -0700, john stultz wrote:
> As I mentioned in the previous mail, I agree the new functionality
> (adjusting the time by an offset instantaneously) is useful, but I'd
> prefer it be done initially within the existing adjtimex() interface.

But the adjtimex does not support nanosecond resolution.
 
> Then if the posix-time clock_id multiplexing version of adjtimex is
> found to be necessary, the new syscall should be introduced, using the
> same API (not all clock_ids need to support all the adjtimex modes, but
> the new interface should be sufficient for NTPd to use).

Would the new syscall need to take a struct timex?

If so, I think it not worth the effort of adding a syscall. Instead,
we can just add "clockid" flags into the mode field.

> There are some other conceptual issues this new syscall introduces:
> 
> 1) While clock_adjtimex(CLOCK_REALTIME,...) would be equivalent to
> adjtimex(), would clock_adjtimex(CLOCK_MONOTONIC,...) make sense? 
> 
> Given CLOCK_MONOTONIC and CLOCK_REALTIME are both based off the same
> notion of time, but offset from each other, any adjustment to one clock
> would be reflected in the other. However, the API would make it seem
> like they could be adjusted independently.

You could adjust the frequency of either one. As a side effect, the
other clock would also be adjusted.

You can only change the time offset on CLOCK_REALTIME, and that would
have no effect on CLOCK_MONOTONIC.

> 2) The same issue in #1 exists for CLOCK_REALTIME/MONOTONIC_COARSE
> variants. 
> 
> 3) Freq steering for MONOTONIC_RAW would defeat the purpose of the
> clock_id.

If I understand correctly, MONOTONIC_RAW is just access to the
hardware counter?
 
> 4) Does adjustments to CPU_TIME clock_ids make sense?

Don't think so.


Thanks,
Richard
