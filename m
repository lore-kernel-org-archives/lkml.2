Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab1LNTVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 14:21:16 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58543 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875Ab1LNTVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 14:21:14 -0500
MIME-Version: 1.0
In-Reply-To: <1323889666.6805.71.camel@work-vm>
References: <cover.1323739287.git.luto@amacapital.net> <20111213032406.GA9604@netboy.at.omicron.at>
 <1323747782.4078.144.camel@work-vm> <CALCETrV8MWwv5ei=4FirhEMyKR5A6hkq4sGSmFqo=mCgopdgXg@mail.gmail.com>
 <20111214074640.GB2180@netboy.at.omicron.at> <1323881310.6805.41.camel@work-vm>
 <20111214183025.GB2465@netboy.at.omicron.at> <1323889666.6805.71.camel@work-vm>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Dec 2011 11:20:52 -0800
Message-ID: <CALCETrXwQXnRRAUZ+h=kR4wUVyfAQyGRd==W47W7LsW7Ci-KAw@mail.gmail.com>
Subject: Re: [RFC 0/2] ABI for clock_gettime_ns
To: john stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>, Arun Sharma <asharma@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 11:07 AM, john stultz <johnstul@us.ibm.com> wrote:
> I don't see a reason to limit clock_gettime_ns() to only CLOCK_TAI.
> After all, while CLOCK_TAI doesn't have leapseconds, it still can be set
> by userland if its wrong, so it doesn't provide the same functionality
> as CLOCK_MONOTONIC. Additionally, the motivation for this new interface
> is for a more efficient CLOCK_THREAD_CPUTIME vdso implementation, so an
> exclusive CLOCK_TAI interface wouldn't serve that need.
>
> I agree adding CLOCK_TAI is an interesting feature, but that could done
> properly with the existing clock_gettime() interface. So I think the
> CLOCK_TAI discussion is really disconnected from the new ABI being
> proposed.

Unless we want the future CLOCK_TAI to also return the UTC offset (or
vice versa), in which case we can use 32 bits of the padding field for
exactly that purpose.  (If TAI and UTC diverge by more than 2^32
seconds, we probably have other things to worry about.  That being
said, it might be useful to add a little more padding at the cost of a
bit of performance.)

--Andy
