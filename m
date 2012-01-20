Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2ATQ3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:29:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63708 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab2ATQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:29:07 -0500
Date: Fri, 20 Jan 2012 20:29:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, david@lang.hm,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
Message-ID: <20120120162900.GP1954@moon>
References: <4F15C249.3000602@zytor.com>
 <m1obu29fnf.fsf@fess.ebiederm.org>
 <alpine.DEB.2.02.1201181404480.6780@asgard.lang.hm>
 <20120118224956.GF15652@moon>
 <m1zkdk4mj5.fsf@fess.ebiederm.org>
 <20120119065541.GA31379@moon>
 <m1ty3rukr1.fsf@fess.ebiederm.org>
 <20120120084008.GD1954@moon>
 <20120120090225.GD2786@moon>
 <4F197F73.3010000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F197F73.3010000@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 06:51:31AM -0800, H. Peter Anvin wrote:
> On 01/20/2012 01:02 AM, Cyrill Gorcunov wrote:
> > On Fri, Jan 20, 2012 at 12:40:08PM +0400, Cyrill Gorcunov wrote:
> > ...
> >> +
> >> +static __init int kcmp_cookie_init(void)
> >> +{
> >> +	int i, j;
> >> +
> >> +	for (i = 0; i < KCMP_TYPES; i++) {
> >> +		for (j = 0; j < 2; j++) {
> >> +			get_random_bytes(&cookies[i][j], sizeof(cookies[i][j]));
> >> +
> >> +			if (cookies[i][j])
> >> +				continue;
> >> +
> >> +			/*
> >> +			 * This is impossible case but just to be sure.
> >> +			 */
> >> +			cookies_valid = false;
> >> +			WARN_ONCE(1, "Can't get random bytes for k-pointers\n");
> >> +		}
> >> +	}
> >> +
> >> +	cookies_valid = true;
> > 
> > darn, this string of course should be on top,
> > i'll update don't complain on this nit.
> > 
> 
> This code is wrong.  You will have a zero cookie, legitimately, once in
> 2^32 or 2^64 attempts, depending on the bitness.
>

We've had kind of emergency pool before which were used in such cases.
These legitime cases can happen not that frequently, so I guess -- can
we use it again?

	if (cookies[i][j])
		continue;
	else
		cookies[i][j] = some-value;

One wont know which exactly values we were using.

> The other thing is that for the multiplicative cookie you should OR in
> the value (~(~0UL >> 1) | 1) in order to make sure that the value is (a)
> large and (b) odd.
> 

I see, i'll update (at first, I occasionally translated odd as 'even' which
made me really scratching the head, until I realized it's 'odd'! :)

	Cyrill
