Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab1LVAUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:20:52 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:49986 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab1LVAUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:20:50 -0500
X-Auth-Info: nlbaIX3WJmNp5RcH/mgKfg96e0Tz6jib2KhU1YrD080=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [resend PATCH for 3.2] procfs: do not confuse jiffies with cputime64_t
References: <m28vmi7ip3.fsf@igel.home> <201112120922.13633.arnd@arndb.de>
	<m21usavwi0.fsf_-_@igel.home>
	<20111212124333.GC14720@tiehlicka.suse.cz>
	<m2wra2uedy.fsf_-_@igel.home>
	<20111212131218.GD14720@tiehlicka.suse.cz>
	<20111221100334.GD27137@tiehlicka.suse.cz>
	<20111221115919.6beac46f.akpm@linux-foundation.org>
	<m24nwtpjj8.fsf@igel.home>
	<20111221155922.1d5688a6.akpm@linux-foundation.org>
X-Yow: I'm pretending that we're all watching PHIL SILVERS
 instead of RICARDO MONTALBAN!
Date: Thu, 22 Dec 2011 01:20:48 +0100
In-Reply-To: <20111221155922.1d5688a6.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 21 Dec 2011 15:59:22 -0800")
Message-ID: <m2vcp9o3rz.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 22 Dec 2011 00:55:07 +0100
> Andreas Schwab <schwab@linux-m68k.org> wrote:
>
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> > Also, in include/asm-generic/cputime.h we have:
>> >
>> > #define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
>> >
>> > But it would be neater to have used nsecs_to_cputime64(), surely.
>> 
>> The procfs interface wants to convert usecs to cputime64, but generic
>> cputime does not have usecs_to_jiffies64.  Once someone writes the
>> latter it can be used here.
>> 
>
> That doesn't address my suggestion.
>
> I'm saying that this:
>
> #define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
>
> should have instead been
>
> #define usecs_to_cputime64(__msecs)	nsecs_to_cputime64((__msecs) * 1000)

It follows the style of the exitsting definitions.  Generic cputime does
not differentiate between jiffies and cputime, so adding a layer of
indirection only here does not increase clarity, IMHO.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
