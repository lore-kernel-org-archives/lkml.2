Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab1EYQHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757457Ab1EYQHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:07:07 -0400
Date: Wed, 25 May 2011 18:06:59 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: Ulrich Keller <uhkeller@googlemail.com>, linux-kernel@vger.kernel.org,
        Thomas Sattler <tsattler@gmx.de>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
Message-ID: <20110525160659.GE19505@random.random>
References: <4DAF6C0B.3070009@gmx.de>
 <loom.20110511T124036-180@post.gmane.org>
 <20110512140352.GG11579@random.random>
 <201105232005.56840.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105232005.56840.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 08:05:55PM +0200, Johannes Hirte wrote:
> Is there any progress on this? I've observed this behavior different times too, 
> with kernel 2.6.39-rc7. After a while working some processes (kmail, 
> akregator, konqueror) got stuck in D state together with the khugepaged task. 
> I could kill the hanging process (kill -n 9) but the khugepaged task stayed in 
> D state.
> The system is a Pentium M (Banias) with 1.3GHz and 1.5G RAM. Attached is the 
> output from multiple SYSRQ+T, content from /proc/zoneinfo and the config.

great progress thanks to your info.

    nr_isolated_file 4294967295

0xffffffff

I didn't check all data you provided yet but the critical bit is we're
off by one in nr_isolated_file and that's the bug, looks unrelated to
anon memory and THP. I'm reviewing more but I recommend everyone to
check this nr_isolated_file code, hoping it's not random memory
corruption. Why it only happened on 32bit so far is unclear though,
you're 32bit too. I doubt it's an overflow, the value is unsigned too,
so it has to be an underflow and that should have happened on 64bit
too in theory.

You and Ulrich both have PREEMPT=y so it may be a preempt bug. What
about you Thomas, do you have PREEMPT=y too?
