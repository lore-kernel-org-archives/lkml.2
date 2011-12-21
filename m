Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1LUTnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:43:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1LUTnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:43:19 -0500
Date: Wed, 21 Dec 2011 11:43:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [resend PATCH for 3.2] procfs: do not confuse jiffies with
 cputime64_t
Message-Id: <20111221114318.014a65fa.akpm@linux-foundation.org>
In-Reply-To: <20111221100334.GD27137@tiehlicka.suse.cz>
References: <m28vmi7ip3.fsf@igel.home>
	<201112120922.13633.arnd@arndb.de>
	<m21usavwi0.fsf_-_@igel.home>
	<20111212124333.GC14720@tiehlicka.suse.cz>
	<m2wra2uedy.fsf_-_@igel.home>
	<20111212131218.GD14720@tiehlicka.suse.cz>
	<20111221100334.GD27137@tiehlicka.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 11:03:34 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> Hmm, it seems that this bugfix (for 3.2) stalled. I guess that it is
> primarily because it is multiarch fix.

No, it's because I'm behind in my lkml reading and nobody cc'ed me on
it.  I'd have got there eventually.

> I am sorry to bother you Andrew but could we push this through you,
> please?

Sure.

> The full patch for reference:
> ---
> >From 1fca39b21f3b344c90c30d98db6dcdcdc6815797 Mon Sep 17 00:00:00 2001
> From: Andreas Schwab <schwab@linux-m68k.org>
> Date: Mon, 12 Dec 2011 14:07:53 +0100
> Subject: [PATCH] procfs: do not confuse jiffies with cputime64_t
> 
> get_{idle,iowait}_time are supposed to return cputime64_t values, not
> jiffies.  Add usecs_to_cputime64 for this.

Changelog is poor.  The patch is described as a bugfix but there's no
description of how the bug affects users.

Without that information I am unable to understand why you think the
patch should be in 3.2, why it should not be in 3.1, etc.  And without
that information, others will find it hard to determine whether this
patch will fix some problem which they or their users are experiencing.

(the patch doesn't apply successfully to 3.1 btw).
