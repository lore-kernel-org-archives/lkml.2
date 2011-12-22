Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1LVKTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:19:19 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:53437 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab1LVKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:19:16 -0500
X-Auth-Info: jCmiTrVC4lGwy/ex6mpLJk//xBjfCHEweRBLCfCQUNE=
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
X-Yow: DON'T go!!  I'm not HOWARD COSELL!!  I know POLISH JOKES...  WAIT!!
 Don't go!!  I AM Howard Cosell!...  And I DON'T know Polish jokes!!
Date: Thu, 22 Dec 2011 11:19:12 +0100
In-Reply-To: <20111221115919.6beac46f.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 21 Dec 2011 11:59:19 -0800")
Message-ID: <m2vcp852ov.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> From: Andreas Schwab <schwab@linux-m68k.org>
> Subject: procfs: do not confuse jiffies with cputime64_t
>
> get_{idle,iowait}_time are supposed to return cputime64_t values, not
> jiffies.  Add usecs_to_cputime64 for this.

Subject: procfs: do not confuse jiffies with cputime64_t

Commit 2a95ea6c0d129b4568fb64e1deda16ceb20e6636 ("procfs: do not
overflow get_{idle,iowait}_time for nohz") did not take into account
that one some architectures jiffies and cputime use different units.
Instead of converting the usec value returned by
get_cpu_{idle,iowait}_time_us to units of jiffies, use the new function
usecs_to_cputime64 to convert it to the correct unit of cputime64_t.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
