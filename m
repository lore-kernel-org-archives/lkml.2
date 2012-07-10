Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab2GJBue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:50:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJBud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:50:33 -0400
Date: Mon, 9 Jul 2012 18:50:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        apw@canonical.com
Subject: Re: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
 added to -mm tree
In-Reply-To: <1341881721.6118.92.camel@joe2Laptop>
Message-ID: <alpine.DEB.2.00.1207091834230.20591@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com> <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com> <1341873376.6118.56.camel@joe2Laptop> <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com> <1341876067.6118.67.camel@joe2Laptop>
 <alpine.DEB.2.00.1207091640170.8185@chino.kir.corp.google.com> <1341881721.6118.92.camel@joe2Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Joe Perches wrote:

> CodingStyle already does suggest parenthesis around sizeof
> 
> 3.1:  Spaces
> 
> Linux kernel style for use of spaces depends (mostly) on
> function-versus-keyword usage.  Use a space after (most) keywords.  The
> notable exceptions are sizeof, typeof, alignof, and __attribute__, which look
> somewhat like functions (and are usually used with parentheses in Linux,
> although they are not required in the language, as in: "sizeof info" after
> "struct fileinfo info;" is declared).
> 
> So use a space after these keywords:
> 	if, switch, case, for, do, while
> but not with sizeof, typeof, alignof, or __attribute__.  E.g.,
> 	s = sizeof(struct file);
> 

This doesn't suggest parenthesis for sizeof at all times, it's saying that 
Linux doesn't use the gcc, glibc, C99 way of doing "sizeof (struct file)" 
for type names as I've already said three times and rather prefers 
"sizeof(struct file)".  That's fine.

I'm talking about the C99 specification that says the sizeof operator act 
on unary expressions, i.e. not type names that you keep talking about and 
apparently don't understand the difference between.  Casts are done with 
type names, you can't do "unsigned long ptr", you do "(unsigned long)ptr".  
Sizeof operators using type names do the same thing: 
"sizeof (unsigned long)".  The space is just a stylistic difference.

You may not understand the difference between a type and a unary 
expression, but other C programmers do, i.e. those who have implemented 
the over 1000 places in the kernel that already do this because they 
learned from K&R.  I guarantee you that those who learned from K&R don't 
think sizeof(unsigned long) "looks like a function".

And typeof is a gnu extension, it's not part of the C99 standard.

> and
> 
> Chapter 14: Allocating memory
> []
> The preferred form for passing a size of a struct is the following:
> 
> 	p = kmalloc(sizeof(*p), ...);
> 

You realize your patch doesn't catch kmalloc(sizeof *p, ...) since it's 
checking for lval and the unary operator '*' is not considered part of an 
identifier, right?  Perhaps you should propose a patch that actually works 
first because yours is busted.
