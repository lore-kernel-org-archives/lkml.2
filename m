Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab2GKIxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:53:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36533 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2GKIxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:53:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120711081419.28567.qmail@science.horizon.com>
References: <20120711081419.28567.qmail@science.horizon.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jul 2012 01:52:55 -0700
X-Google-Sender-Auth: lXe0AvE6sheMLCJ5jzuMZWWLnNs
Message-ID: <CA+55aFwcJgAFiow1sSo7mkF9n0MpTw80gjAszazyBrRcmbph-g@mail.gmail.com>
Subject: Re: + checkpatch-add-check-for-use-of-sizeof-without-parenthesis.patch
 added to
To: George Spelvin <linux@horizon.com>
Cc: joe@perches.com, linux-kernel@vger.kernel.org, rientjes@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 1:14 AM, George Spelvin <linux@horizon.com> wrote:
>
> Huh.  I prefer sizeof without parens, like I prefer return without parens.

Umm. The two have *nothing* to do with each other.

> It actually annoys me when I see someone write
>
>         return(0);

Absolutely. Anybody who does that is just terminally confused.
"return()" is in no way a function.

But "sizeof()" really *is* a function. It acts exactly like a function
of it's argument. There is no reason to not treat it that way. Sure,
the C standard *allows* you to not have parenthesis around an
expression argument, but you should treat that as the parsing oddity
it is, nothing more. There is zero reason not to have the parenthesis
there.

In contrast, "return" can never be part of an expression, and the
parenthesis never make any sense.

With "return", there's no precedence issues, for example.

With "sizeof()" there are: sizeof(x)+1 is very different from
sizeof(x+1), and having the parenthesis there make it clearer for
everybody (sure, you can write the first one as "sizeof x + 1", but
let's face it, the precedence is way more obvious if you just think of
sizeof as a function).

Here's an example of a really bad use of "sizeof" that doesn't have
the parenthesis around the argument: sizeof(*p)->member. Quite
frankly, if you do this, you should be shot. It makes people have to
parse the C precedence rules by hand. In contrast, parsing
sizeof((*p)->member) is *way* easier for humans.

And let's face it: if you write your code so that it's easy to parse
for a machine, and ignore how easy it is to parse for a human, I don't
want you writing kernel code. There's a reason we have the coding
standards. They aren't for the *compiler*. They are for *humans*.

And humans should think of sizeof() as a function, not as some
ass-backwards special case C parsing rule that is subtle as hell.

                  Linus
