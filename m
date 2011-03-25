Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1CYSQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:16:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33074 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab1CYSQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:16:24 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=s8bQjA_BN_cA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=86U65m-h4kyeZu7suGgA:9 a=g6hcjU623_lIVJUvGiZwQdg5oHsA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Allow use in if() statements
 on UP
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, peterz@infradead.org,
        akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        laijs@cn.fujitsu.com, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTikfq9bz_cKdvq9ab+KS218Q7uVvoNdJeMe_-RUg@mail.gmail.com>
References: <20110317192208.444147791@goodmis.org>
	 <tip-2092e6be82ec71ecbf5a8ceeef004bbcbdb78812@git.kernel.org>
	 <AANLkTikfq9bz_cKdvq9ab+KS218Q7uVvoNdJeMe_-RUg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Mar 2011 14:16:21 -0400
Message-ID: <1301076981.14261.197.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 09:45 -0700, Linus Torvalds wrote:
> On Fri, Mar 25, 2011 at 3:48 AM, tip-bot for Steven Rostedt
> <srostedt@redhat.com> wrote:
> > -# define WARN_ON_SMP(x)                        do { } while (0)
> > +# define WARN_ON_SMP(x)                        ({0;})
> 
> That's a VERY odd way of writing "0".
> 
> Am I missing something subtle?

I thought about using "0", but when WARN_ON_SMP() is used outside of an
if statement, it turns into:

	0;

Which seems strange to me. Thus the ({0;}) was basically a way to state
that this is also a function and not just a 0 value.

Also, a quick test shows that

	0;

gives the warning:

	"warning: statement with no effect"

-- Steve


