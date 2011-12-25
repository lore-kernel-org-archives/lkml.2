Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab1LYEGm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 23:06:42 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37940 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab1LYEGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 23:06:40 -0500
MIME-Version: 1.0
In-Reply-To: <20111224065043.GA6292@netboy.at.omicron.at>
References: <cover.1323739287.git.luto@amacapital.net> <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm> <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
 <20111214074640.GB2180@netboy.at.omicron.at> <1323881310.6805.41.camel@work-vm>
 <20111214183025.GB2465@netboy.at.omicron.at> <1323889666.6805.71.camel@work-vm>
 <20111222120326.GA3360@cherladcori01> <CALCETrUFLu1ekyaJFve4zARER7od-RyVy-JM+VsBBMgxvAFyoQ@mail.gmail.com>
 <20111224065043.GA6292@netboy.at.omicron.at>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 24 Dec 2011 20:06:18 -0800
Message-ID: <CALCETrVrqiu77n8HgRMaiiWY4uu9pMt92gSqm1X7K=EcS+i1bA@mail.gmail.com>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
To: Richard Cochran <richardcochran@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:50 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> On Fri, Dec 23, 2011 at 09:59:04PM -0800, Andy Lutomirski wrote:
>
>> I've written the patch and it's not as big an improvement as I hoped.
>> I'll play with it a bit and send it out soon.
>
> Andy, can you say what the motivation or use case is?

Simplicity and performance.  Many users (e.g. I) use clock_gettime to
measure elapsed time.  We just end up converting to flat nanoseconds
over and over.  This syscall avoids the conversion.

The added padding bits will allow UTC/TAI offset and/or sub-nanosecond
precision in the future if someone wants to add them.

I seem to be saving just over one nanosecond per call on my laptop,
which isn't that impressive.  The real-world improvement may be better
-- calling clock_gettime in a tight loop should give very good branch
prediction success, which will make the cost of the loops that flat ns
avoids seem a little lower than they are.

I'll send patches in the morning.

--Andy

>
> Just curious,
>
> Richard



-- 
Andy Lutomirski
AMA Capital Management, LLC
Office: (310) 553-5322
Mobile: (650) 906-0647
