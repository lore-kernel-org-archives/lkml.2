Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1DVQFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:05:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48743 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab1DVQFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:05:44 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=Ar9dcRiOBTsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=SyI_GHdlAAAA:8 a=6uzdhVk9xL31gy9iTt0A:9 a=PUjeQqilurYA:10 a=UQxMgyrMzRwA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to
 use Linux style comparisons
From: Steven Rostedt <rostedt@goodmis.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: John Reiser <jreiser@bitwagon.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <BANLkTim8mBo3fz9f=quABj-=ycpA+G7q1g@mail.gmail.com>
References: <20110421022825.535486725@goodmis.org>
	 <20110421023737.290712238@goodmis.org> <4DB19A1E.8070806@bitwagon.com>
	 <BANLkTim8mBo3fz9f=quABj-=ycpA+G7q1g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 22 Apr 2011 12:05:41 -0400
Message-ID: <1303488341.6225.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 12:52 -0300, Thiago Farina wrote:
> On Fri, Apr 22, 2011 at 12:09 PM, John Reiser <jreiser@bitwagon.com> wrote:
> > I consider "0==strcmp(" to be an idiom.  Too often "strcmp(...) == 0"
> > overflows my mental stack because of the typographic width of the operands
> > in the source code.  If you still object in this case then please consider
> > using something like:
> >        #define strequ(a,b) (strcmp((a), (b)) == 0)
> > or
> >        static int strequ(char const *a, char const *b)
> >        {
> >                return strcmp(a, b) == 0;
> >        }
> > which names the idiom.
> >
> 
> Maybe str_eq? Or even just streq? And also just !strcmp(a,b).

streq() is something I woudn't mind.

I've too often confused !strcmp(a,b) as "!streq()" which is not the
case. Which is why I always use strcmp(a,b) == 0, which to me I see the
'==' as eq. I also consider strcmp(a,b) != 0 as not equal. Again, the
mind that sees "==" and "!=" can just translate that to human language.
Where !strcmp() is just gibberish ;)

-- Steve


