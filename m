Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1HFHfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 03:35:16 -0400
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:37718
	"EHLO qmta06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab1HFHfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 03:35:11 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Aug 2011 03:35:11 EDT
Message-ID: <4E3CED1A.2040200@gentoo.org>
Date: Sat, 06 Aug 2011 03:28:26 -0400
From: Joshua Kinard <kumba@gentoo.org>
User-Agent: Mozilla/5.0 (Windows NT 6.0; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Willy Tarreau <w@1wt.eu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Greear <greearb@candelatech.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable] [patch 3/3] rtc: Limit frequency
References: <20110722091011.717194327@linutronix.de>  <20110722091045.537404938@linutronix.de>  <20110722150550.1878f069.akpm@linux-foundation.org>  <20110722223915.GA22405@1wt.eu>  <4E3B660E.3020108@gentoo.org> <1312535060.2764.12.camel@work-vm>
In-Reply-To: <1312535060.2764.12.camel@work-vm>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 05:04, John Stultz wrote:
> Yea, I submitted a slightly different version of Thomas' patch which set
> it to 8192Hz via the tip tree, but the original one went upstream first.
> I'm away from home right now, so I'll be re-submitting just that change
> probably next week.

Awesome, I'll look out for it if I get free time to look at the RTC driver I have.  It's broken now due to a loss of
__symbol_get(), as I was trying to find a way to make the driver determine if it was a module or not.


> I'm torn here. It would be good to have the functionality listed in some
> way so it is documented. However as we abstract the RTC to be more of an
> internal tool for the kernel, rather then hardware directly addressed
> from userland, the PIE mode is really not as useful (and quite messier
> to multiplex).  I'd much rather try to extend the alarm interfaces to
> allow for higher resolution, so it could be used as a alarmed highres
> oneshot timer if the hardware supports it.

That's why I think a wrapper would be best.  By default, it would use the hrtimer code and so, none of the existing
drivers would need to be modified.  Any driver that wants to, however, could override the base functions if they wanted
to provide that functionality separately.  It should probably be a CONFIG_* option, though.  Right now, consumers of
DS1685 are rare: old SGI O2 systems and some embedded board from 'electronic systems Gmbh', one of whose employees wrote
the original driver about 2 years ago.  The driver I have now handles older versions (DS1689/1693) and the more common
DS17x8y versions, and those I think are the most modern.  Not sure what systems use those, however.

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
4096R/D25D95E3 2011-03-28

"The past tempts us, the present confuses us, the future frightens us.  And our lives slip away, moment by moment, lost
in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
