Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2IERHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:07:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36226 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752246Ab2IERHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:07:12 -0400
Message-ID: <1346864831.1906.3.camel@joe2Laptop>
Subject: Re: [PATCH v2] checkpatch: Suggest using min_t or max_t
From: Joe Perches <joe@perches.com>
To: Philippe De Muyter <philippe.demuyter@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Wed, 05 Sep 2012 10:07:11 -0700
In-Reply-To: <CAOoYnzLViwqp11Tw1zf0C+qhc+AtzefNLzZEbC2oUPkWPV5zqQ@mail.gmail.com>
References: <20110525165345.5f775c7b.akpm@linux-foundation.org>
	 <7f59aa30d3af02ae522dc38105e51107e34826f2.1306455946.git.joe@perches.com>
	 <CAOoYnzLViwqp11Tw1zf0C+qhc+AtzefNLzZEbC2oUPkWPV5zqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 13:21 +0200, Philippe De Muyter wrote:
> On 5/27/11, Joe Perches <joe@perches.com> wrote:
> > A common issue with min() or max() is using a cast on
> > one or both of the arguments when using min_t/max_t could
> > be better.
> >
> > Add cast detection to uses of min/max and suggest an
> > appropriate use of min_t or max_t instead.
> >
> > Caveat:  This only works for min() or max() on a single line.
> >          It does not find min() or max() split across multiple lines.
> >
> > This does find:
> > 	min((u32)foo, bar);
> > But it does not find:
> > 	max((unsigned long)foo,
> > 	    bar);
> >
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >
> > v2: Make $match_balanced_parentheses work in perl 5.8
> 
> Has this been applied  ?
> 
> v3.3 version of checkpatch.pl works for me, but v3.4, v3.5 & v3.6rc2 say:
> Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++
> <-- HERE |(?-1))*\))/ at scripts/checkpatch.pl line 340.
> 
> and my perl is :
> 
>         perl --version
> 
>         This is perl, v5.8.8 built for i586-linux-thread-multi

The current version of checkpatch skips this
check when the perl version is less than 5.10.0


commit d7c76ba7e58bc3ca674f20759c686535db484749
Author: Joe Perches <joe@perches.com>
Date:   Tue Jan 10 15:09:58 2012 -0800

    checkpatch: improve memset and min/max with cast checking
    
    Improve the checking of arguments to memset and min/max tests.
    
    Move the checking of min/max to statement blocks instead of single line.
    Change $Constant to allow any case type 0x initiator and trailing ul
    specifier.  Add $FuncArg type as any function argument with or without a
    cast.  Print the whole statement when showing memset or min/max messages.
    Improve the memset with 0 as 3rd argument error message.
    
    There are still weaknesses in the $FuncArg and $Constant code as arbitrary
    parentheses and negative signs are not generically supported.

[]
# Using $balanced_parens, $LvalOrFunc, or $FuncArg
# requires at least perl version v5.10.0
# Any use must be runtime checked with $^V
[]
# typecasts on min/max could be min_t/max_t
		if ($^V && $^V ge 5.10.0 &&
		    defined $stat &&
		    $stat =~ /^\+(?:.*?)\b(min|max)\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\)/) {


