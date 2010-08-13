Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0HMHbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:31:24 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37378 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab0HMHbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:31:23 -0400
Subject: Re: Problem with commit deda2e81961e96be4f2c09328baca4710a2fd1a0
From: john stultz <johnstul@us.ibm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C64B93A.5010403@lwfinger.net>
References: <4C64571F.6000606@lwfinger.net>
	 <1281646368.4002.66.camel@localhost.localdomain>
	 <4C64B93A.5010403@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 00:30:38 -0700
Message-ID: <1281684638.3940.11.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 22:17 -0500, Larry Finger wrote:
> On 08/12/2010 03:52 PM, john stultz wrote:
> > 
> > Ugh. I'm surprised it picks *this* loop to optimize instead of the
> > similar one right above. I'm guessing its the local raw_nsecs value, but
> > whatever.  Also surprised Jason's testing didn't hit this issue, but its
> > probably a gcc version thing.
> > 
> > Regardless, I clearly need to give i386 more love in my testing.
> > My profuse apologies.
> > 
> > As suggested by Linus, here's the do_div explicit version. It builds ok
> > on i386 & x86_64, but I have not yet tested it. 
> > 
> > Larry, Jason: Could you verify it works for you (and avoids the original
> > issue)?
> 
> This one builds for me with both compilers. It appears to run OK. As to the
> original issue - I don't think I ever saw the problem. I'll leave that question
> for Jason.

Thanks for the testing! 

I also managed to trigger the link issue with a 64bit gcc-4.3 cross
compiling to 32bit. However both 32bit and 64bit gcc-4.4 didn't trigger
the link issue, so it looks like its fixed in gcc.

Regardless, after my own testing, the change looks good to me. Raw time
is accumulating properly relative to monotonic time.

Assuming Jason has no complaints it should be able to be pushed in.

Thanks again for the quick reporting and verification.
-john


