Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2ATQ6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:58:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41800 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab2ATQ6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:58:10 -0500
Message-ID: <4F199CE7.3020900@zytor.com>
Date: Fri, 20 Jan 2012 08:57:11 -0800
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
References: <4F15C249.3000602@zytor.com> <m1obu29fnf.fsf@fess.ebiederm.org> <alpine.DEB.2.02.1201181404480.6780@asgard.lang.hm> <20120118224956.GF15652@moon> <m1zkdk4mj5.fsf@fess.ebiederm.org> <20120119065541.GA31379@moon> <m1ty3rukr1.fsf@fess.ebiederm.org> <20120120084008.GD1954@moon> <20120120090225.GD2786@moon> <4F197F73.3010000@zytor.com> <20120120162900.GP1954@moon>
In-Reply-To: <20120120162900.GP1954@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 08:29 AM, Cyrill Gorcunov wrote:
>
> We've had kind of emergency pool before which were used in such cases.
> These legitime cases can happen not that frequently, so I guess -- can
> we use it again?
>
> 	if (cookies[i][j])
> 		continue;
> 	else
> 		cookies[i][j] = some-value;
>
> One wont know which exactly values we were using.
>

I would not worry about get_random_bytes() returning nothing... if so, a 
lot of other places in the kernel would be broken.

>> The other thing is that for the multiplicative cookie you should OR in
>> the value (~(~0UL>>  1) | 1) in order to make sure that the value is (a)
>> large and (b) odd.
>>
>
> I see, i'll update (at first, I occasionally translated odd as 'even' which
> made me really scratching the head, until I realized it's 'odd'! :)
>
> 	Cyrill

