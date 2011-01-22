Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1AVKO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 05:14:58 -0500
Received: from www.tglx.de ([62.245.132.106]:38919 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab1AVKO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 05:14:57 -0500
Date: Sat, 22 Jan 2011 11:14:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Torben Hohn <torbenh@gmx.de>
cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com
Subject: Re: make arch code use xtime_update() instead of do_timer() 
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
Message-ID: <alpine.LFD.2.00.1101221105420.2971@localhost6.localdomain6>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, Torben Hohn wrote:
 
> move do_timer() into kernel/time/timekeeping.c
> and provide a version which properly takes the xtime_lock()
> 
> finally makes do_timer() and xtime_lock into a header file
> private to kernel/time
> 
> xtime_lock is still used by kernel/hrtimer.c and kernel/time.c
> i am not sure, whether the small header file is the right
> thing though.

get_jiffies_64() and the jiffies export should move into
kernel/time/jiffies.c

The hrtimer bits should be replaced by a function in timekeeping.c
which collects xtime and wall_to_monotonic.

Thanks,

	tglx
