Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab2GJCtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:49:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64558 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab2GJCtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:49:22 -0400
Date: Mon, 9 Jul 2012 19:49:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, apw@canonical.com
Subject: Re: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
 added to -mm tree
In-Reply-To: <CA+55aFwey-q4716pYYSi=3R_ucw84zFspDXMXmzvzc72XSc9Lg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207091933320.25143@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com> <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com> <1341873376.6118.56.camel@joe2Laptop> <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com> <1341876067.6118.67.camel@joe2Laptop>
 <alpine.DEB.2.00.1207091640170.8185@chino.kir.corp.google.com> <1341881721.6118.92.camel@joe2Laptop> <alpine.DEB.2.00.1207091834230.20591@chino.kir.corp.google.com> <CA+55aFwey-q4716pYYSi=3R_ucw84zFspDXMXmzvzc72XSc9Lg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Linus Torvalds wrote:

> sizeof without parenthesis is an abomination, and should never be used.
> 
> Sure, you don't need to have the parenthesis (except when you do - for
> actual types), but it's a parsing oddity.
> 
> The sane solution is: just add the f*cking parenthesis, and don't use
> the parsing oddity.
> 
> The parenthesis are *required* when it is a type, and they are a nice
> clarification (and makes the code easier to read) when it's an
> expression. Not having them is insane, because it just makes it clear
> how odd the parsing rules are for the two different cases.
> 

It's only strange looking because Documentation/CodingStyle doesn't use 
the gcc, glibc, C99, K&R, etc, style of doing "sizeof (struct foo)" and 
rather requires "sizeof(struct foo)".

> Think of it as a function, and get over your idiotic pissing match
> over how long you've both known C. That's irrelevant. It's a C builtin
> function with (unnecessarily) odd parsing rules that the kernel tries
> to standardize. The fact that it can take a type is the least odd part
> of it (there are other built-in C extensions that look like functions
> and do special things with the arguments they get -
> __builtin_constant_p(), __builtin_choose_expr() etc - they don't
> evaluate the *value* of the argument either).
> 

The only thing I've asked for is that something like this be added to 
Documentation/CodingStyle and not just in checkpatch.pl since hardly 
anybody uses that perl script.  You've chosen to mandate 
"sizeof(struct foo)" over "sizeof (struct foo)" in that document, which 
makes parenthesis for all unary expressions of the sizeof operator 
stylistically better as well, so it's only reasonable to ask that it 
mandates them for all unary expressions of sizeof.  It's your kernel.  
(That will be an exception for sizeof unary expressions, though, since we 
certainly don't want to mandate (i++).)

So, as I've been saying the whole thread, please either mandate it kernel-
wide in the CodingStyle or don't do it in checkpatch.  Checkpatch 
continually acts as a backdoor way of people enforcing their own 
preferences over others.
