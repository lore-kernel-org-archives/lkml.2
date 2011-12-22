Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1LVKSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:18:46 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:44638 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab1LVKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:18:42 -0500
X-Auth-Info: 2+XT+DMe5829EN11amvTAHyt/XHepAYXHTn2or/3Ygg=
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
	<m2zkelo428.fsf@igel.home>
	<20111221161944.ec1c49f9.akpm@linux-foundation.org>
X-Yow: A KAISER ROLL?!  What good is a Kaiser Roll without a little
 COLE SLAW on the SIDE?
Date: Thu, 22 Dec 2011 11:18:36 +0100
In-Reply-To: <20111221161944.ec1c49f9.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 21 Dec 2011 16:19:44 -0800")
Message-ID: <m2wr9o52pv.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 22 Dec 2011 01:14:39 +0100
> Andreas Schwab <schwab@linux-m68k.org> wrote:
>
>> > a) what effect does this problem have upon users of the kernel?
>> 
>> get_idle_time returns the value in the wrong unit.
>
> So the "idle" fields in /proc/stat are wrong.
>
> We're getting there!  Now, in what way are they wrong?

They use the wrong unit, off by the factor between jiffies and cputime.

> How could a kernel maintainer recognise that this patch is needed?

By running the kernel on one of the architectures that are affected (did
I already say that on most architectures jiffies and cputime are
equivalent?).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
