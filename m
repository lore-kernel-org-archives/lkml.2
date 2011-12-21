Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1LUX71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:59:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1LUX70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:59:26 -0500
Date: Wed, 21 Dec 2011 15:59:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Michal Hocko <mhocko@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [resend PATCH for 3.2] procfs: do not confuse jiffies with
 cputime64_t
Message-Id: <20111221155922.1d5688a6.akpm@linux-foundation.org>
In-Reply-To: <m24nwtpjj8.fsf@igel.home>
References: <m28vmi7ip3.fsf@igel.home>
	<201112120922.13633.arnd@arndb.de>
	<m21usavwi0.fsf_-_@igel.home>
	<20111212124333.GC14720@tiehlicka.suse.cz>
	<m2wra2uedy.fsf_-_@igel.home>
	<20111212131218.GD14720@tiehlicka.suse.cz>
	<20111221100334.GD27137@tiehlicka.suse.cz>
	<20111221115919.6beac46f.akpm@linux-foundation.org>
	<m24nwtpjj8.fsf@igel.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 00:55:07 +0100
Andreas Schwab <schwab@linux-m68k.org> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > Also, in include/asm-generic/cputime.h we have:
> >
> > #define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
> >
> > But it would be neater to have used nsecs_to_cputime64(), surely.
> 
> The procfs interface wants to convert usecs to cputime64, but generic
> cputime does not have usecs_to_jiffies64.  Once someone writes the
> latter it can be used here.
> 

That doesn't address my suggestion.

I'm saying that this:

#define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)

should have instead been

#define usecs_to_cputime64(__msecs)	nsecs_to_cputime64((__msecs) * 1000)

