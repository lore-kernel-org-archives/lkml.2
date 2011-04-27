Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab1D0RIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:08:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53749 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab1D0RIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:08:02 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=O9R5ObWvzxquC6a1yYsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110427164639.GD9487@ZenIV.linux.org.uk>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110427164639.GD9487@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Apr 2011 13:07:59 -0400
Message-ID: <1303924079.18763.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 17:46 +0100, Al Viro wrote:
> On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> > This macro is arguably more readable than its variants:
> > - !strcmp(a, b)
> > - strcmp(a, b) == 0
> 
> Strongly NACKed.  As far as I'm concerned, it's in the same shitbucket as
> bcopy(3), bzero(3) et.al.  Use idiomatic C; extensions of that kind are
> *bad*, since new developers have to learn them.

What developer has to really learn streq()? I mean it is pretty obvious
to what it does, as suppose to what bzero and bcopy do. A quick google
on "streq" brings up lots of matches of people who already do this.

Actually, some have "optimized" it with:

#define streq(a, b) (*(a) == *(b) && strcmp(a, b) == 0)

As it fails out if the first character does not match (likely the case
if strings do not match) before it calls the strcmp function.

-- Steve


