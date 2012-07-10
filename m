Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2GJCDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:03:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50875 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752782Ab2GJCDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:03:23 -0400
Message-ID: <1341885802.6118.101.camel@joe2Laptop>
Subject: Re: +
 checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch added to
 -mm tree
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        apw@canonical.com
Date: Mon, 09 Jul 2012 19:03:22 -0700
In-Reply-To: <alpine.DEB.2.00.1207091834230.20591@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
	 <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com>
	 <1341873376.6118.56.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com>
	 <1341876067.6118.67.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091640170.8185@chino.kir.corp.google.com>
	 <1341881721.6118.92.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091834230.20591@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 18:50 -0700, David Rientjes wrote:
> On Mon, 9 Jul 2012, Joe Perches wrote:
> 
> > CodingStyle already does suggest parenthesis around sizeof
> > 
> > 3.1:  Spaces
> > 
> > Linux kernel style for use of spaces depends (mostly) on
> > function-versus-keyword usage.  Use a space after (most) keywords.  The
> > notable exceptions are sizeof, typeof, alignof, and __attribute__, which look
> > somewhat like functions (and are usually used with parentheses in Linux,
> > although they are not required in the language, as in: "sizeof info" after
> > "struct fileinfo info;" is declared).
> > 
> > So use a space after these keywords:
> > 	if, switch, case, for, do, while
> > but not with sizeof, typeof, alignof, or __attribute__.  E.g.,
> > 	s = sizeof(struct file);
> > 
> 
> This doesn't suggest parenthesis for sizeof at all times,

Depends on interpretation.  Linus' email from 2008 is pretty clear.

> it's saying that 
> Linux doesn't use the gcc, glibc, C99 way of doing "sizeof (struct file)" 
> for type names as I've already said three times and rather prefers 
> "sizeof(struct file)".  That's fine.
> 
> I'm talking about the C99 specification that says the sizeof operator act 
> on unary expressions, i.e. not type names that you keep talking about and 
> apparently don't understand the difference between.  Casts are done with 
> type names, you can't do "unsigned long ptr", you do "(unsigned long)ptr".  
> Sizeof operators using type names do the same thing: 
> "sizeof (unsigned long)".  The space is just a stylistic difference.
> 
> You may not understand the difference between a type and a unary 
> expression, but other C programmers do, i.e. those who have implemented 
> the over 1000 places in the kernel that already do this because they 
> learned from K&R.

I don't really care what style a large block of code
uses.  I care that it mostly has the same form.

fyi:  I learned C from K&R and Bill Joy in the mid 70's.

> I guarantee you that those who learned from K&R don't 
> think sizeof(unsigned long) "looks like a function".

Tell that to Linus. He wrote the email I referenced
which you so apparently blithely elided.

Repeating it:

"Another example of this is "sizeof". The kernel universally (I hope) has 
parenthesis around the sizeof argument, even though it's clearly not 
required by the C language."

> And typeof is a gnu extension, it's not part of the C99 standard.

Irrelevant as Linux uses it.

> You realize your patch doesn't catch kmalloc(sizeof *p, ...) since it's 
> checking for lval and the unary operator '*' is not considered part of an 
> identifier, right?

Oh look, useful feedback instead of useless carping about
how much I know or don't know c.

> Perhaps you should propose a patch that actually works 
> first because yours is busted.

I have one here.  I'll forward it soonish.

