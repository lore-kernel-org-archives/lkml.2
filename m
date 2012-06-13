Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2FMH4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:56:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41007 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2FMH4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:56:42 -0400
Date: Wed, 13 Jun 2012 09:56:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, nzimmer@sgi.com, joe@perches.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3] watchdog: Quiet down the boot messages
Message-ID: <20120613075637.GA18819@gmail.com>
References: <1339445050-29941-1-git-send-email-dzickus@redhat.com>
 <20120611211239.GA12721@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611211239.GA12721@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> On Mon, Jun 11, 2012 at 04:04:10PM -0400, Don Zickus wrote:
>  > A bunch of bugzillas have complained how noisy the nmi_watchdog is during
>  > boot-up especially with its expected failure cases (like virt and bios
>  > resource contention).
>  > 
>  > This is my attempt to quiet them down and keep it less confusing for the end
>  > user.  What I did is print the message for cpu0 and save it for future
>  > comparisons.  If future cpus have an identical message as cpu0, then don't
>  > print the redundant info.  However, if a future cpu has a different message,
>  > happily print that loudly.
> 
> Would anyone object to compressing these lines too ?
>  
>  >     ... version:                2
>  >     ... bit width:              40
>  >     ... generic registers:      2
>  >     ... value mask:             000000ffffffffff
>  >     ... max period:             000000007fffffff
>  >     ... fixed-purpose events:   3
>  >     ... event mask:             0000000700000003
> 
> That's a lot of wasted space, that could just as easily take 
> up two lines without losing readability.

Yeah, we can do that, this was early debug code.

I'd suggest compressing it further, to a single line, to 
something like:

 ... ver: 2, regs: 2/3, bits: 40, masks: 0xffffffffff/0x700000003/0x7fffffff

Thanks,

	Ingo
