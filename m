Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1LVAOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:14:43 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:43887 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1LVAOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:14:41 -0500
X-Auth-Info: zGRQzWs6rZqqL2y0se8Te08afHsSHYQxEOcceI2GuR8=
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
	<m28vm5pjrl.fsf@igel.home>
	<20111221155624.1555d8a4.akpm@linux-foundation.org>
X-Yow: Okay, BARBRA STREISAND, I recognize you now!!  Also EFREM ZIMBALIST,
 JUNIOR!!  And BEAUMONT NEWHALL!!  Everybody into th' BATHROOM!
Date: Thu, 22 Dec 2011 01:14:39 +0100
In-Reply-To: <20111221155624.1555d8a4.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 21 Dec 2011 15:56:24 -0800")
Message-ID: <m2zkelo428.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 22 Dec 2011 00:50:06 +0100
> Andreas Schwab <schwab@linux-m68k.org> wrote:
>
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>> > From: Andreas Schwab <schwab@linux-m68k.org>
>> > Subject: procfs: do not confuse jiffies with cputime64_t
>> >
>> > get_{idle,iowait}_time are supposed to return cputime64_t values, not
>> > jiffies.  Add usecs_to_cputime64 for this.
>> 
>> For most architectures (which use the asm-generic/cputime.h) jiffies use
>> the same unit as cputime64_t values, but ia64, powerpc and s390 make
>> them different.
>> 
>
> OK, but
>
> a) what effect does this problem have upon users of the kernel?

get_idle_time returns the value in the wrong unit.

> b) which kernel version(s) are affected?

get_idle_time got broken in 2a95ea6c0d129b4568fb64e1deda16ceb20e6636.

$ git tag --contains a25cac5198d4ff2842ccca63b423962848ad24b2
v3.2-rc1
v3.2-rc2
v3.2-rc3
v3.2-rc4
v3.2-rc5
v3.2-rc6

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
