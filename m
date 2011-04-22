Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1DVQNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:13:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab1DVQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:13:49 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=Ar9dcRiOBTsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=GYJz13CEpy9cZMDoB9QA:9 a=krOk4hSmcVqTpj2z6F0A:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to
 use Linux style comparisons
From: Steven Rostedt <rostedt@goodmis.org>
To: John Reiser <jreiser@bitwagon.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4DB19A1E.8070806@bitwagon.com>
References: <20110421022825.535486725@goodmis.org>
	 <20110421023737.290712238@goodmis.org>  <4DB19A1E.8070806@bitwagon.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 22 Apr 2011 12:13:46 -0400
Message-ID: <1303488826.6225.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 08:09 -0700, John Reiser wrote:
> On 04/20/2011 07:28 PM, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The Linux style for comparing is:
> > 
> >   var == 1
> >   var > 0
> > 
> > and not:
> > 
> >   1 == var
> >   0 < var
> > 
> > It is considered that Linux developers are smart enough not to do the
> > 
> >   if (var = 1)
> > 
> > mistake.
> 
> It's not just a matter of 'smart', it's a matter of safety.
> For me it still catches a bug (typo, copy+paste, fumble in editor script, ...)
> every year or two.  Compilers haven't always warned, or the option to warn
> might be turned off.


I totally understand why it is used. But personally, it confuses my
train of thought when reading code. That notation is just a work around
to a deficiency in the C language. And I find the time spent trying to
decipher 0 == var takes up much more time than debugging if (var = 0).

Although, I have no idea why you choose the 0 < var, that totally
confuses me. It does not play any role in assignments. What bug is that
preventing? When I want to know if a variable is greater than zero, I
don't show it as zero less than the var.

> 
> > -	return 0 == strcmp(".text",           txtname) ||
> > +	return strcmp(".text",           txtname) == 0 ||
> 
> I consider "0==strcmp(" to be an idiom.  Too often "strcmp(...) == 0"
> overflows my mental stack because of the typographic width of the operands
> in the source code.  If you still object in this case then please consider
> using something like:
> 	#define strequ(a,b) (strcmp((a), (b)) == 0)
> or
> 	static int strequ(char const *a, char const *b)
> 	{
> 		return strcmp(a, b) == 0;
> 	}
> which names the idiom.

I'm all for making a streq. Perhaps that could be a nice clean up of the
kernel. It definitely makes it much easier to read and understand. But
that is for another time.

As I'm working on this code, and I'm the maintainer, I want to make sure
I can read and review the code easily. Anything that distracts me for
other people's personal taste, is something that I don't have the luxury
of time for. Thus, I'm keeping these patches as is for the time being.

-- Steve



