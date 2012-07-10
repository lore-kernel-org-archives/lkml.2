Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2GJC3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:29:23 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46401 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2GJC3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:29:22 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207091834230.20591@chino.kir.corp.google.com>
References: <20120709215256.9A4F71E0043@wpzn4.hot.corp.google.com>
 <alpine.DEB.2.00.1207091514310.32082@chino.kir.corp.google.com>
 <1341873376.6118.56.camel@joe2Laptop> <alpine.DEB.2.00.1207091553120.3552@chino.kir.corp.google.com>
 <1341876067.6118.67.camel@joe2Laptop> <alpine.DEB.2.00.1207091640170.8185@chino.kir.corp.google.com>
 <1341881721.6118.92.camel@joe2Laptop> <alpine.DEB.2.00.1207091834230.20591@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jul 2012 19:28:57 -0700
X-Google-Sender-Auth: onT47Gyt_BI9udVH06enfTl-bNY
Message-ID: <CA+55aFwey-q4716pYYSi=3R_ucw84zFspDXMXmzvzc72XSc9Lg@mail.gmail.com>
Subject: Re: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
 added to -mm tree
To: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, apw@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 6:50 PM, David Rientjes <rientjes@google.com> wrote:
>
> This doesn't suggest parenthesis for sizeof at all times

sizeof without parenthesis is an abomination, and should never be used.

Sure, you don't need to have the parenthesis (except when you do - for
actual types), but it's a parsing oddity.

The sane solution is: just add the f*cking parenthesis, and don't use
the parsing oddity.

The parenthesis are *required* when it is a type, and they are a nice
clarification (and makes the code easier to read) when it's an
expression. Not having them is insane, because it just makes it clear
how odd the parsing rules are for the two different cases.

And talking about "prefix operators" is a moronic thing to do. It does
*not* look like a prefix operator, and it does not even *act* like a
prefix operator (look at types, where it really does require the
parenthesis). But most importantly, it's not how sane people think
about it.

Think of it as a function, and get over your idiotic pissing match
over how long you've both known C. That's irrelevant. It's a C builtin
function with (unnecessarily) odd parsing rules that the kernel tries
to standardize. The fact that it can take a type is the least odd part
of it (there are other built-in C extensions that look like functions
and do special things with the arguments they get -
__builtin_constant_p(), __builtin_choose_expr() etc - they don't
evaluate the *value* of the argument either).

Btw, the spacing rule is separate, and the "3.1 Spaces" thing was
added later and is in fact somewhat misleading. The spacing rules have
nothing to do with "function-vs-keyword", and everything to do with
"function-vs-control-flow". So "sizeof()" is not actually an exception
at all, like the docs state: it's perfectly regular. It looks and acts
as a function, not as a control flow operation.

What makes if/while/else/do/for stand out is that they are the native
C control flow operators, and they have spaces around them. They fact
that they are keywords is irrelevant. OF COURSE they are keywords,
since they are the native control flow ops, but that is not why they
have special spacing rules. The reason they have special spacing rules
is that

    for (x; y; z) {

is a control flow construct, while

    function(x, y, z);

is just a normal function expression. And in *no* case do we put
spaces after the parenthesis, we do it after the comma (or semicolon
for "for (a; b; c)").

We do have some control flow macros ("list_for_each()" etc), and they
could logically have the space, but hey, they are also normal macros,
so whatever. The kernel special-cases the native control-flow stuff,
not the random control flow macro oddities we've created for special
occasions.

                Linus
