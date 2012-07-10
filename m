Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2GJAzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:55:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56630 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751873Ab2GJAzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:55:22 -0400
Message-ID: <1341881721.6118.92.camel@joe2Laptop>
Subject: Re: +
 checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch added to
 -mm tree
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        apw@canonical.com
Date: Mon, 09 Jul 2012 17:55:21 -0700
In-Reply-To: <alpine.DEB.2.00.1207091640170.8185@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
	 <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com>
	 <1341873376.6118.56.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com>
	 <1341876067.6118.67.camel@joe2Laptop>
	 <alpine.DEB.2.00.1207091640170.8185@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 16:47 -0700, David Rientjes wrote:
> On Mon, 9 Jul 2012, Joe Perches wrote:
> 
> > > So, nack, don't start enforcing your own coding style and preferences in 
> > > checkpatch.pl.
> > 
> > Not just my opinion.
> > 
> > https://lkml.org/lkml/2008/12/23/138
> > --------------------------------------------------------
> > Date: Tue, 23 Dec 2008 10:08:50 -0800 (PST)
> > From: Linus Torvalds <>
> > []
> > Another example of this is "sizeof". The kernel universally (I hope) has 
> > parenthesis around the sizeof argument, even though it's clearly not 
> > required by the C language. 
> > 
> 
> Well, let's add Linus to the cc then because it's certainly not a C 
> standard.  The sizeof operator requires parenthesis for type names, you 
> can't do "sizeof unsigned long", for example, it requires 
> "sizeof (unsigned long)".  All other unary operators do not need the 
> parenthesis by ANY C standard.
> 
> Documentation/CodingStyle does not ask for the parenthesis to be added 
> just like it doesn't ask for parenthesis to do things like (i++); which is 
> another unary operator.

CodingStyle already does suggest parenthesis around sizeof

3.1:  Spaces

Linux kernel style for use of spaces depends (mostly) on
function-versus-keyword usage.  Use a space after (most) keywords.  The
notable exceptions are sizeof, typeof, alignof, and __attribute__, which look
somewhat like functions (and are usually used with parentheses in Linux,
although they are not required in the language, as in: "sizeof info" after
"struct fileinfo info;" is declared).

So use a space after these keywords:
	if, switch, case, for, do, while
but not with sizeof, typeof, alignof, or __attribute__.  E.g.,
	s = sizeof(struct file);

and

Chapter 14: Allocating memory
[]
The preferred form for passing a size of a struct is the following:

	p = kmalloc(sizeof(*p), ...);


