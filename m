Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1CQSnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:43:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1CQSnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:43:39 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=MpKEIbNVzpcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2ZvwQofU_4GQ0dSiVv0A:9 a=RHrx6QgK_YYq_1HRUnBsiPuc72EA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        laijs@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com
In-Reply-To: <1300387122.6315.407.camel@edumazet-laptop>
References: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
	 <1300370936.16880.96.camel@gandalf.stny.rr.com>
	 <AANLkTi=Z_yYkdwzO7TMs7nSMOXR9wn_7BxtKjOKgS5HL@mail.gmail.com>
	 <1300380909.16880.264.camel@gandalf.stny.rr.com>
	 <1300381340.6315.323.camel@edumazet-laptop>
	 <1300385802.16880.348.camel@gandalf.stny.rr.com>
	 <AANLkTim4hY_HJrukNjVe5RDzBj7r547BcxKRozKcQ_uE@mail.gmail.com>
	 <1300387122.6315.407.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 14:43:37 -0400
Message-ID: <1300387417.16880.399.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 19:38 +0100, Eric Dumazet wrote:
>  
> 
> My point was that WARN_ON(X) always evaluates X once
> 
> And apparently, WARN_ON_SMP(X) doesnt evaluates X iF !SMP
> 
> This should be documented, or fixed ;)

My new patch has it documented. I even explain when to use the _SMP()
version, which is mainly for !spin_is_locked() as spin_is_locked()
always returns false, and !0 will trigger the warning.

It can also be used to test values that only exist in SMP.

struct foo {
	[...]
#ifdef CONFIG_SMP
	int bar;
#endif
};


	WARN_ON_SMP(zoo->bar);

We don't want that zoo->bar even evaluated for that case.

-- Steve



