Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2LJKlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:41:12 -0500
Received: from multi.imgtec.com ([194.200.65.239]:54488 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2LJKlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:41:10 -0500
Message-ID: <50C5BC05.6020502@imgtec.com>
Date: Mon, 10 Dec 2012 10:40:05 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [braindump][RFC] signals and syscall restarts (Re: [PATCH v2
 19/44] metag: Signal handling)
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-20-git-send-email-james.hogan@imgtec.com> <20121205171609.GW4939@ZenIV.linux.org.uk> <50C07ECE.9070602@imgtec.com> <20121206220955.GZ4939@ZenIV.linux.org.uk>
In-Reply-To: <20121206220955.GZ4939@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_10_10_41_06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/12 22:09, Al Viro wrote:
> On Thu, Dec 06, 2012 at 11:17:34AM +0000, James Hogan wrote:
> 
>> Agreed, it looks wrong. Looking at the sh version, is there a particular
>> reason to only check for -EFAULT and not the other errors that
>> do_sigaltstack can return (-EPERM, -EINVAL, and -ENOMEM)?
> 
> See commit fae2ae2a900a5c7bb385fe4075f343e7e2d5daa2

Thanks :)

> 
>>> BTW, what's to stop the syscall restart triggering if you catch a signal
>>> while in rt_sigreturn(2)?
>>
>> I'm not sure I understand how that could cause a problem. Could you
>> elaborate the sequence of events?
>>
>> The signal restart is triggered by the return value register, so
>> rt_sigreturn would have to return -ERESTART*. This could happen if the
>> signal handler overwrote the return value in the sigcontext (which as
>> far as I can tell could also happen on ARM), or if the syscall that was
>> originally interrupted by the signal has -ERESTARTNOINTR ||
>> (-ERESTARTSYS && SA_RESTART), but in that case rt_sigreturn has already
>> switched back to the context of the original syscall so that's the right
>> thing to do isn't it? I've probably missed something important :-)
> 
> [we probably need something along the lines of braindump below in 
> somewhere in Documentation/*; comments and improvements are very
> welcome - this is just a starting point.  We *do* need some coherent
> explanation of signal semantics, judging by how often people step on
> the same landmines...]

Thanks, this helps a lot.

Cheers
James

