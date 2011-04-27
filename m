Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1D0BcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:32:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1D0BcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:32:04 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=CoApHu1UbJB_HPmVXOAA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110427005243.GI9486@thunk.org>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110427005243.GI9486@thunk.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Apr 2011 21:32:01 -0400
Message-ID: <1303867921.18763.45.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 20:52 -0400, Ted Ts'o wrote:
> On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> > This macro is arguably more readable than its variants:
> > - !strcmp(a, b)
> > - strcmp(a, b) == 0
> > 
> > Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> 
> I don't think this is not a good idea.
> 
> First of all, changing 2800 instances of strcmp will induce a huge
> amount of code churn, that will cause patches to break, etc.  And
> whether streq() looks better is going to be very much a case of
> personal preference.  I'm so used to !strcmp(a, b) that streq(a, b)
> would be harder for me, just because I'm not used to it.
> 
> So I'd NACK a change like this to any parts of the kernel that I'm
> maintaining.  If another people feel that way, it's not clear that
> having two different conventions in the kernel would necessarily help...
> 

I agree that this entire thing is all about personal preference, and
that a lot of these conventions is determined by who maintains the code.

This all started when I changed code that I need to maintain from:

	if (0 == var)

to

	if (var == 0)

I understand why the first is done, but it just trips me up every time I
see it.

I also prefer:

	if (strcmp(a, b) == 0)

over

	if (!strcmp(a, b))

because the ! in that statement makes my mind say "a != b". But again,
this is all about preference.

As for me, I would not mind a streq() as it is a different
function/macro, that I would not get it confused with strcmp().

I acked the patch, because I would not NAK changes that converted the
strcmp() to streq() in my code (as long as it was done correctly).

-- Steve


