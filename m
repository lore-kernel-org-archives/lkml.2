Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1BQEc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 23:32:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621Ab1BQEc4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 23:32:56 -0500
MIME-Version: 1.0
In-Reply-To: <20110217042519.GH14534@fieldses.org>
References: <20110215185902.GG29420@fieldses.org> <20110217042519.GH14534@fieldses.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Feb 2011 20:32:06 -0800
Message-ID: <AANLkTikeK77v7y346-OX9dvufJSjbJ7qQSpJc4C3wLrZ@mail.gmail.com>
Subject: Re: 2.6.38 nfsd bugfixes
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 8:25 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> -               if ((host_err = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
> -                       goto out_nfserr;
> +               if ((status = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
> +                       return status;

Btw, can we please just agree to not doing those idiotic double parenthesis?

There is a really trivial solution to the gcc warning - write your
code like a sane person, instead of some ex-LISP hacker that has
withdrawal symptoms. IOW, the above should be written as

  status = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid);
  if (status)
    return status;

which is a hell of a lot more readable, no?

There is never any real excuse to put an assignment inside a regular
if-statement.

Inside a while/for loop? Sure. There are real syntactic reasons for
doing things like

   while ((c = getchar()) != EOF) {
   }

that actually make the code better and denser and avoid extra control
flow crap or duplicate code.

Inside a macro expansion? Again, there may be good reasons to try to
make it a single statement.

But a simple if-statement? There just isn't any reason for it, since
the obvious thing is to just write it as two separate statements: the
assignment, and the if-statement. So why do it and make the code
uglier and harder to parse?

                                   Linus
