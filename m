Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab0HUDpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 23:45:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35787 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab0HUDpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 23:45:03 -0400
Message-ID: <4C6F4BBB.5040207@zytor.com>
Date: Fri, 20 Aug 2010 20:44:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Mark Stanovich <mrktimber@gmail.com>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.3
References: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com>
In-Reply-To: <AANLkTi=wyG13QOU3EQwaO3qBxY=aR=ftiP4s7YpemrPp@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2010 08:40 PM, Mark Stanovich wrote:
> After updating to the 2.6.35.3 stable release, my machine was rebooting
> automatically during the first few seconds of boot.
> 
> I bisected to the first bad commit of
> 
> commit 568132624386f53e87575195d868db
> 9afb2e9316
> Author: H. Peter Anvin <hpa@zytor.com <mailto:hpa@zytor.com>>
> Date:   Tue Jul 27 17:01:49 2010 -0700
> 
>     x86: Add memory modify constraints to xchg() and cmpxchg()
>    
>     commit 113fc5a6e8c2288619ff7e8187a6f556b7e0d372 upstream.
>    
>     xchg() and cmpxchg() modify their memory operands, not merely read
>     them.  For some versions of gcc the "memory" clobber has apparently
>     dealt with the situation, but not for all.
>    
> I noticed that the latest version pulled from Linus's git tree did not
> have the problem.  After looking at the changes to
> arch/x86/include/asm/cmpxchg_32.h, I cherry-picked two patches from
> Linus's tree that seemed to make a difference, namely:
> 
> 69309a05907546fb686b251d4ab041c26afe1e1d
> 4532b305e8f0c238dd73048068ff8a6dd1380291
> 
> Applying these patches solved the rebooting problem on 2.6.35.3
> 
> I believe the same problem also happens for the latest stable version of
> 2.6.34, but did not verify the fix worked for the 2.6.34 stable releases.
> 
> I don't know if this is helpful, but I thought I would let you know in
> case someone else is having the same problem.
> 
> If you need any further information, just let me know.
> 

Yes, as a matter of fact, we have been trying to root-cause this
problem; please see:

https://bugzilla.kernel.org/show_bug.cgi?id=16612

If you could try the one-liner in there and see if it solves your
problem, it would be great.

	-hpa

P.S. What version of gcc do you use?

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

