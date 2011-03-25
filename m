Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1CYTki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:40:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40986 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1CYTkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:40:37 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=s8bQjA_BN_cA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=kS3S4LvwYuzGJLQhBccA:9 a=B4yFmaYKDVIYKF9zeo4Gt2yQmV4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Allow use in if() statements
 on UP
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, akpm@linux-foundation.org, srostedt@redhat.com,
        tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20110325193128.GA5839@p183.telecom.by>
References: <20110317192208.444147791@goodmis.org>
	 <tip-2092e6be82ec71ecbf5a8ceeef004bbcbdb78812@git.kernel.org>
	 <AANLkTikfq9bz_cKdvq9ab+KS218Q7uVvoNdJeMe_-RUg@mail.gmail.com>
	 <1301076981.14261.197.camel@gandalf.stny.rr.com>
	 <1301077163.14261.199.camel@gandalf.stny.rr.com>
	 <20110325193128.GA5839@p183.telecom.by>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 25 Mar 2011 15:40:34 -0400
Message-ID: <1301082034.14261.202.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 21:31 +0200, Alexey Dobriyan wrote:

> > Would you like me to add a comment that states:
> > 
> > 	/*
> > 	 * Use ({0;}) as just "0" will cause gcc to output:
> > 	 *   warning: statement with no effect
> > 	 */
> 
> Try ((void)0)

Maybe I should update the comment to stop further confusion:

	/*
	 * Use ({0;}) as it works nicely in both an if statement and
	 * as a stand alone line statement.
	 *   "0;" causes "warning: statement with no effect"
	 *   ((void)0) does not work in an if () condition.
	 */

-- Steve


