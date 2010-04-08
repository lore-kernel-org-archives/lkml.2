Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab0DHQEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:04:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677Ab0DHQEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 12:04:20 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler fix
References: <20100408153854.GA5055@elte.hu>
	<alpine.LFD.2.00.1004080839350.3544@i5.linux-foundation.org>
X-Yow: I just heard the SEVENTIES were over!!  And I was just getting in touch
 with my LEISURE SUIT!!
Date: Thu, 08 Apr 2010 18:03:52 +0200
In-Reply-To: <alpine.LFD.2.00.1004080839350.3544@i5.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 8 Apr 2010 08:42:38 -0700 (PDT)")
Message-ID: <m3ljcylymv.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 8 Apr 2010, Ingo Molnar wrote:
>>  
>> -	if (len < nr_cpu_ids)
>> +	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
>>  		return -EINVAL;
>
> Not that it really matters, but this will now fail for no good reason if 
> you pass it a half-gigabyte area due to overflow.

Which can easily be avoided.

	if (len < DIV_ROUND_UP(nr_cpu_ids, BITS_PER_BYTE))

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
