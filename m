Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1CQSc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:32:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1CQSc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:32:56 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=MpKEIbNVzpcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=UUbrR5ZaR5cvT35v2fUA:9 a=HnA9alz8swiss8JDHKrUNRWmyI8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: um: WARNING: at kernel/futex.c:786 __unqueue_futex
From: Steven Rostedt <rostedt@goodmis.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        laijs@cn.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net, dvhart@linux.intel.com
In-Reply-To: <1300386121.16880.359.camel@gandalf.stny.rr.com>
References: <AANLkTi=e+tM-WTerLmkZfLTQqKCLsJHVBgQ5sj+TMjc4@mail.gmail.com>
	 <1300370936.16880.96.camel@gandalf.stny.rr.com>
	 <AANLkTi=Z_yYkdwzO7TMs7nSMOXR9wn_7BxtKjOKgS5HL@mail.gmail.com>
	 <1300380909.16880.264.camel@gandalf.stny.rr.com>
	 <1300381340.6315.323.camel@edumazet-laptop>
	 <AANLkTik6oHOOk+1paSmCs=0c03_J10wGBFrRMQw-Jo86@mail.gmail.com>
	 <1300386121.16880.359.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 14:32:50 -0400
Message-ID: <1300386770.16880.383.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 14:22 -0400, Steven Rostedt wrote:
> On Thu, 2011-03-17 at 18:43 +0100, Geert Uytterhoeven wrote:
> 
> > I don't know. It's not clear to me if "WARN_ON_SMP(x)" should always return "x",
> > or only on SMP?
> > 
> > E.g.
> > 
> >     if (WARN_ON_SMP(x)) {
> >        // Should we get here if "x" is true?
> >        // Or only if CONFIG_SMP and "x" are both true?
> >     }
> > 
> 
> The "Or only if CONFIG_SMP and "x" are both true.
> 
> I'll update the change to add a comment about that.
> 

We are the first user of this false return, as do { } while (0) doesn't
return anything. I'll add a comment to explain the issue, but it makes
sense to have it returns false on UNIPROCESSOR.

-- Steve


