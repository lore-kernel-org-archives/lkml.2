Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2ATOwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:52:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41309 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2ATOwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:52:30 -0500
Message-ID: <4F197F73.3010000@zytor.com>
Date: Fri, 20 Jan 2012 06:51:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
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
References: <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com> <20120117144452.GG16213@moon> <4F15C249.3000602@zytor.com> <m1obu29fnf.fsf@fess.ebiederm.org> <alpine.DEB.2.02.1201181404480.6780@asgard.lang.hm> <20120118224956.GF15652@moon> <m1zkdk4mj5.fsf@fess.ebiederm.org> <20120119065541.GA31379@moon> <m1ty3rukr1.fsf@fess.ebiederm.org> <20120120084008.GD1954@moon> <20120120090225.GD2786@moon>
In-Reply-To: <20120120090225.GD2786@moon>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 01:02 AM, Cyrill Gorcunov wrote:
> On Fri, Jan 20, 2012 at 12:40:08PM +0400, Cyrill Gorcunov wrote:
> ...
>> +
>> +static __init int kcmp_cookie_init(void)
>> +{
>> +	int i, j;
>> +
>> +	for (i = 0; i < KCMP_TYPES; i++) {
>> +		for (j = 0; j < 2; j++) {
>> +			get_random_bytes(&cookies[i][j], sizeof(cookies[i][j]));
>> +
>> +			if (cookies[i][j])
>> +				continue;
>> +
>> +			/*
>> +			 * This is impossible case but just to be sure.
>> +			 */
>> +			cookies_valid = false;
>> +			WARN_ONCE(1, "Can't get random bytes for k-pointers\n");
>> +		}
>> +	}
>> +
>> +	cookies_valid = true;
> 
> darn, this string of course should be on top,
> i'll update don't complain on this nit.
> 

This code is wrong.  You will have a zero cookie, legitimately, once in
2^32 or 2^64 attempts, depending on the bitness.

The other thing is that for the multiplicative cookie you should OR in
the value (~(~0UL >> 1) | 1) in order to make sure that the value is (a)
large and (b) odd.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

