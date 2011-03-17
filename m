Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1CQUhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:37:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43841 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1CQUhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:37:06 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=cjxWWOd7KoAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Qj5cvEdX0C3vHeXm78sA:9 a=Lz18qa7JarDe-N7M8EYK1ZCCGRkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: make checkpatch warn about memset with swapped arguments.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110317200215.GA4084@redhat.com>
References: <20110317045209.GA18656@redhat.com>
	 <20110317193645.GD14675@home.goodmis.org>
	 <20110317200215.GA4084@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Mar 2011 16:37:04 -0400
Message-ID: <1300394224.16880.518.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 16:02 -0400, Dave Jones wrote:
> On Thu, Mar 17, 2011 at 03:36:45PM -0400, Steven Rostedt wrote:
> 
>  > > +		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {
>  > 
>  > Wouldn't this be a better regex:
>  > 
>  > 	if ($line =~ /memset.*\,\s*(0x)?0\s*\)\s*;/)
> 
> I dunno, regexps are all gobble-de-gook to me.  Why is it better ?

:) I love regex :)

But the reason for better is more robust. This will catch other bad
things users may do, like having tabs and such instead of spaces. Or
they may have more than one space. Although this should be caught by
other errors or warnings in checkpatch.

\s stands for any whitespace, 
so ",\s*x" is ,[any-amount-of-white-space]x"

The (0x)? is common for (0x|) in perl, but either is fine. I'm just use
to the '?' one.

-- Steve


