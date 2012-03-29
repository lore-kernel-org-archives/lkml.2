Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab2C2MW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab2C2MWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:22:21 -0400
Date: Thu, 29 Mar 2012 14:22:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] perf tools: Including pre-generated flex files
Message-ID: <20120329122208.GC6949@m.brq.redhat.com>
References: <20120327181547.GA7374@infradead.org>
 <CA+55aFynFze+AJxUtkiAaOTJ58cK8=aiDi-fQqQ3bDV54w-=+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFynFze+AJxUtkiAaOTJ58cK8=aiDi-fQqQ3bDV54w-=+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 12:46:25PM -0700, Linus Torvalds wrote:
> On Tue, Mar 27, 2012 at 11:15 AM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> >
> >        But Ingo argues that flex and bison are just a yum/whatever
> > install away, so we shouldn't clutter the kernel git history with things
> > we can generate at build time.
> >
> >        What is your take on this?
> 
> I think I agree.
> 
> Building the *basic* kernel is different - I want people to be able to
> build the kernel and install it and test it out with a fairly minimal
> development environment.
> 
> But the perf tools
>  (a) are mainly useful for developers who can easily install these
> things *anyway* (ie we're not talking the same kind of usage cases
> where we want to encourage random people off the street to build and
> test)
>  (b) already require things that are *much* less common than flex (ie
> the whole libelf-devel stuff etc)
> so I think having pre-generated lex/yacc files is just silly - just
> install the tool.
> 
>                     Linus


I just tried to generate the parser on RHEL6 and got:

    CC util/parse-events-bison.o
util/parse-events-bison.c:222:6: error: "YYENABLE_NLS" is not defined
util/parse-events-bison.c:664:6: error: "YYLTYPE_IS_TRIVIAL" is not
defined

looks like bison bug, that RHEL6 did not picked up fix for yet.

I agree with not including the parser sources in git, but we'll probably
get some screaming from ppl having similar issue like above.

Also I'm not fully sure we could even use generated bison/flex
files cross architectures.. need to check :)

jirka
