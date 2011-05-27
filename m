Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1E0USa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:18:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33680 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1E0US2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:18:28 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=kJ--3F4o5PMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=h6K80ukqYzVPM5Oo16QA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch v4] checkpatch: Signature format verification
From: Steven Rostedt <rostedt@goodmis.org>
To: anish singh <anish198519851985@gmail.com>
Cc: Joe Perches <joe@perches.com>, Manish Kumar Singh <man.k1983@gmail.com>,
        davej@redhat.com, apw@shadowen.org, akpm@linux-foundation.org,
        vapier@gentoo.org, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi=dsYi3ViZdpGdagxzhzDRuRVL_+A@mail.gmail.com>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306519311.1918.12.camel@anish-desktop>
	 <1306520991.31864.9.camel@Joe-Laptop>
	 <BANLkTikfh_ABGomn-Lm9Ugc7MzeRodwiEQ@mail.gmail.com>
	 <1306523288.31864.29.camel@Joe-Laptop>
	 <BANLkTi=JK+XS2D0exj=unjpjGCsnVncCzQ@mail.gmail.com>
	 <1306524822.31864.50.camel@Joe-Laptop>
	 <BANLkTi=dsYi3ViZdpGdagxzhzDRuRVL_+A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 27 May 2011 16:18:26 -0400
Message-ID: <1306527506.3857.41.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-28 at 01:24 +0530, anish singh wrote:
> 

>         
>         Anish, do you have a response to this?
> Your approach is correct but i am trying to do in my own way.

Why?? Correct is more important than individual preferences.

>         
>         > I have replaced b/w with "between".
>         > And as Manish rightly exlained this patch is not meant for
>         > email validation.
>         
>         
>         Yet it does incorrectly anyway to nominally skip
>         name and find <.*>.  That's the problem.
>         
>         Look again at the patterns:
>         
>         +                               if ($line =~ /^\s*$sign(.*)/i)
>         {
>         +                                       if ($1 !~ /^\s
>         +([a-zA-Z\s\"\.\-\'\,]*.*)/i) {

Note, why the []? Because you basically have:

	/^\s+([blahblah]*.*)/

which is the same as:

	/^\s+(.*)/

>         +                                               WARN("Space
>         required after $sign\n" .
>         +
>         $herecurr);
>         
>         +                                       }
>  
> here i am trying to check space between sign & name.
> In first if loop i am checking if sign is present in line or not.
> If yes, enter into second if loop & check if $1 starts with space 
> or not(which takes care of checking space between sign & name).
> In this if loop again i am catching name & rest of the things in $1.
> $1 will be used for checking space between name & mail-id.

BTW, people hate perl for this very reason. This subtle changing of $1
is very hard to follow if you are not a perl expert. I use perl all the
time (recordmcount.pl and ktest.pl), but if you look at my code, you
will see that I purposely avoid these subtle characteristics of perl,
because that's the (very rightfully so) reason people complain that perl
is a write once and never maintain language.

I understood from the beginning what you were doing, but I had to think
about it more than I should have.

>         
>         and
>         
>         +                                       if ($1 !~ /([\sa-zA-Z
>         \"\.\-\'\,]*)\s<.*>/i) {
>         +                                               WARN("Space
>         required b/w Full Name & Mail-id:\n" .
>         +
>         $herecurr);
>         
>         +                                       }


You really need to get a new MUA.
>         
>         
>  
> In this If loop i am using $1 (returned by earlier pattern)  to check
> space 
> between mail and <mail-id>.
> If we print $1 after last if loop, we can get name appropriately.
> So, i am not skipping name here to match <>.
>  
> I will change <.*> to <.*?> (non-greedy match) for matching very first
> enclosing bracket.

Again, this doesn't explain the space warning when I have just his:

 Signed-off-by: <me@foo.bar>

Because that will not match the above, because the $1 will be
"<me@foo.bar>". With no space.


-- Steve



