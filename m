Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab0FSCXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 22:23:10 -0400
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:34995 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751391Ab0FSCXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 22:23:01 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: tX6AGMwVM1lnEkbOQTZFCwLX4v4_m0YhtwPnipQuReyFWOq
 QTeDPenOileVjIWAjz61G8h7HGiZrY5ue64LVn3KFhWVh2.Ig5bF5uVOAoTU
 Lxt3IYHeXua9xSx_BwtXMgPAYjBTdO21xOsiiOxTXzXEc1L8InU.uSjRfeYC
 7LQhKtMcRYK1ERtJJt95dO4qTdZ7BqZq074uTJYixY.BEQYvbY.lbW88P9t7
 f__mV6e314LUB1AEu0Zjx13ZxJ1u.X_3Wi6.9w8oRkGM0as_8QcFJf0c6YdF
 K0kRHkqyPSeW9vy99HYeUcfeSYBSty7O6m6.2wHxssI9LlJaoh741NW9p
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4C1C2A07.8020007@schaufler-ca.com>
Date: Fri, 18 Jun 2010 19:23:03 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kees Cook <kees.cook@canonical.com>,
       Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-doc@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
References: <20100616221833.GM24749@outflux.net>	<20100617000120.13071be8@lxorguk.ukuu.org.uk>	<20100616232230.GP24749@outflux.net>	<alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>	<20100617170453.GV24749@outflux.net>	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>	<20100617140630.c6ced27a.rdunlap@xenotime.net>	<20100617221815.68ce30c5@lxorguk.ukuu.org.uk>	<20100617215105.GB24749@outflux.net>	<20100617233054.330256cf@lxorguk.ukuu.org.uk>	<4C1AE3A8.2020104@schaufler-ca.com>	<E1FEE555-566E-4698-8FD8-240076A4F850@mit.edu> <m1wrtwwiua.fsf@fess.ebiederm.org>
In-Reply-To: <m1wrtwwiua.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Theodore Tso <tytso@MIT.EDU> writes:
>
>   
>> i think we really need to have stacked LSM's,

!

>>  because there is a large set
>> of people who will never use SELinux.  Every few years, I take another 
>> look at SELinux, my head explodes with the (IMHO unneeded complexity),
>> and I go away again...
>>
>> Yet I would really like a number of features such as this ptrace scope idea ---
>> which I think is a useful feature, and it may be that stacking is the only
>> way we can resolve this debate.   The SELinux people will never believe that
>> their system is too complicated, and I don't like using things that are impossible
>> for me to understand or configure, and that doesn't seem likely to change anytime
>> in the near future.
>>
>> I mean, even IPSEC RFC's are easier for me to understand, and that's saying
>> a lot...
>>     
>
>
> If anyone is going to work on this let me make a concrete suggestion.
> Let's aim at not stacked lsm's but chained lsm's, and put the chaining
> logic in the lsm core.
>   

It's 35 years since my data structures course. What's the important
difference between the two?

> The core difficulty appears to be how do you multiplex the security pointers
> on various objects out there.
>   

That and making sure that the hooks that maintain state get called
even if the decision to deny access has already been made by someone
else.

> My wishlist has this working so that I can logically have a local security
> policy in a container, restricted by the global policy but with additional
> restrictions.
>
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

