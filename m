Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1HEDqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:46:40 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:47313 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967Ab1HEDqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:46:38 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Aug 2011 23:46:38 EDT
Message-ID: <4E3B660E.3020108@gentoo.org>
Date: Thu, 04 Aug 2011 23:39:58 -0400
From: Joshua Kinard <kumba@gentoo.org>
User-Agent: Mozilla/5.0 (Windows NT 6.0; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Greear <greearb@candelatech.com>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable] [patch 3/3] rtc: Limit frequency
References: <20110722091011.717194327@linutronix.de> <20110722091045.537404938@linutronix.de> <20110722150550.1878f069.akpm@linux-foundation.org> <20110722223915.GA22405@1wt.eu>
In-Reply-To: <20110722223915.GA22405@1wt.eu>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 18:39, Willy Tarreau wrote:
> On Fri, Jul 22, 2011 at 03:05:50PM -0700, Andrew Morton wrote:
>> On Fri, 22 Jul 2011 09:12:51 -0000
>> Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>>> The RTC hrtimer is self rearming. We really need to limit the
>>> frequency to something sensible.
>>
>>> Cc: stable@kernel.org
>>
>> Why?  What failures does the current code cause?  What effect do these
>> failures have upon users?
> 
> I would add that if we go that route, we should at least accept values
> that were documented as possible till now. Man rtc says 2 Hz to 8192 Hz,
> but Thomas' proposed patch limits it to 5000 Hz, so some breakage is to
> be expected.
> 
> Regards,
> Willy

To me, it would make sense to lock it at 8192Hz.  I re-wrote a driver for the DS1685 family of Dallas chips that I need
to cleanup and re-submit, but in researching that specific RTC, I really could not find an RTC out there that went above
8192.

Arguably, 32768Hz might also work.  The DS1685 runs at this mode normally, but it disables PIE when it does.

My vote is 8192Hz.

Also, can we get a wrapper of some kind in the RTC core to allow an RTC driver to override the hrtimer /PIE emulation if
needed?  I have in the DS1685 driver full support for its PIE mode and really do not want to gut it as part of the
cleanup.  Some kind of override API would be nice in case anyone ever runs into this chip (or its family members).

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org

"The past tempts us, the present confuses us, the future frightens us.  And our lives slip away, moment by moment, lost
in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
