Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab1CTJCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 05:02:16 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58055 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1CTJCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 05:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=HoTnGvLTakZ6CRuo/eQ93JQ6VuT4xGaWwhSlwfvJrUNDxfwRDze8kNCy4QFOWQlpuT
         wwtqkymXEfBCgw+Gwhb7TvQXMNag49J2ev32+xSDXeZrR6FY9qObVGir9etuA9iOjw6A
         Jr1yta5dZ4NSse6wR6YBwetIMJCC1cqtPmczY=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	<20110317211548.646b04d2@tpl.lwn.net>
	<1300419170.16880.956.camel@gandalf.stny.rr.com>
	<AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
	<AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
	<Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
Date: Sun, 20 Mar 2011 11:02:10 +0200
X-Google-Sender-Auth: Blt-gZngvKYMGajO5zEQVGlNT6Q
Message-ID: <AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Pekka Enberg <penberg@kernel.org>
To: Julia Lawall <julia@diku.dk>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Palix <npalix@diku.dk>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Sun, Mar 20, 2011 at 10:01 AM, Julia Lawall <julia@diku.dk> wrote:
> Suggestions for how to make it easier to use or the documentation more
> understandable are welcome.

The benefit of scripts/checkpatch.pl is that it doesn't require any
setting up to do. I'm personally less likely to use Coccinelle (and
Sparse for that matter) on boxes where the software is not installed.
I'm not sure how other people feel about it, but I'd personally love
to see tools/coccinelle and tools/sparse.

As for something more concrete, I guess this is what I'm mostly interested in:

penberg@jaguar:~/src/linux$ make C=1 CHECK="scripts/coccicheck" mm/slub.o

I guess it'd be good to document that for 'make help' because now you
need to dig through Documentation/coccinelle.txt to find it.

P.S. It seems there's a bug somewhere because the above command fails
miserably for me:

  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHECK   mm/slub.c
File "/home/penberg/src/linux/scripts/coccinelle/api/memdup_user.cocci",
line 32, column 5,  charpos = 747
    around = '<+...', whole content = -    <+... when != goto l2;
Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty
context: <+...")
File "/home/penberg/src/linux/scripts/coccinelle/api/memdup_user.cocci",
line 32, column 5,  charpos = 747
    around = '<+...', whole content = -    <+... when != goto l2;
Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty
context: <+...")
File "/home/penberg/src/linux/scripts/coccinelle/api/memdup_user.cocci",
line 32, column 5,  charpos = 747
    around = '<+...', whole content = -    <+... when != goto l2;
Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty
context: <+...")
File "/home/penberg/src/linux/scripts/coccinelle/api/memdup_user.cocci",
line 32, column 5,  charpos = 747
    around = '<+...', whole content = -    <+... when != goto l2;
Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty
context: <+...")
make[1]: *** [mm/slub.o] Error 1
make: *** [mm/slub.o] Error 2

penberg@jaguar:~/src/linux$ dpkg -l|grep coccinelle
ii  coccinelle                                      0.2.2.deb-2
                                        semantic patching tool for C

[ I'm on Ubuntu 10.10. ]

                        Pekka
