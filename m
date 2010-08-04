Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0HDKAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:00:20 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:51836 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab0HDKAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:00:18 -0400
Date: Wed, 4 Aug 2010 10:58:12 +0100
From: Chris Webb <chris@arachsys.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Over-eager swapping
Message-ID: <20100804095811.GC2326@arachsys.com>
References: <20100802124734.GI2486@arachsys.com>
 <AANLkTinnWQA-K6r_+Y+giEC9zs-MbY6GFs8dWadSq0kh@mail.gmail.com>
 <20100803033108.GA23117@arachsys.com>
 <AANLkTinjmZOOaq7FgwJOZ=UNGS8x8KtQWZg6nv7fqJMe@mail.gmail.com>
 <20100803042835.GA17377@localhost>
 <20100803214945.GA2326@arachsys.com>
 <20100804022148.GA5922@localhost>
 <AANLkTi=wRPXY9BTuoCe_sDCwhnRjmmwtAf_bjDKG3kXQ@mail.gmail.com>
 <20100804032400.GA14141@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804032400.GA14141@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> writes:

> This is interesting. Why is it waiting for 1m here? Are there high CPU
> loads? Would you do a
> 
>         echo t > /proc/sysrq-trigger
> 
> and show us the dmesg?

Annoyingly, magic-sysrq isn't compiled in on these kernels. Is there another
way I can get this info for you? Replacing the kernels on the machines is a
painful job as I have to give the clients running on them quite a bit of
notice of the reboot, and I haven't been able to reproduce the problem on a
test machine.

I also think the swap use is much better following a reboot, and only starts
to spiral out of control after the machines have been running for a week or
so.

However, your suggestion is right that the CPU loads on these machines are
typically quite high. The large number of kvm virtual machines they run mean
thatl oads of eight or even sixteen in /proc/loadavg are not unusual, and
these are higher when there's swap than after it has been removed. I assume
this is mostly because of increased IO wait, as this number increases
significantly in top.

Cheers,

Chris.
