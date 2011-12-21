Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1LUXuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:50:17 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:60210 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1LUXuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:50:14 -0500
X-Auth-Info: /fO22fU+x1jNAIt2OY5WDA5wwgtXGJ1f+cWiDSBmDXU=
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
X-Yow: My EARS are GONE!!
Date: Thu, 22 Dec 2011 00:50:06 +0100
In-Reply-To: <20111221115919.6beac46f.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 21 Dec 2011 11:59:19 -0800")
Message-ID: <m28vm5pjrl.fsf@igel.home>
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

For most architectures (which use the asm-generic/cputime.h) jiffies use
the same unit as cputime64_t values, but ia64, powerpc and s390 make
them different.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
