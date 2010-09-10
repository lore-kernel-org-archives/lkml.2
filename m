Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab0IJJak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:30:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1615 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0IJJaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:30:39 -0400
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warnings for static char
 that could be static const char
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100910090615.GA3644@shadowen.org>
References: <1284056536.24986.182.camel@Joe-Laptop>
	 <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
	 <1284060106.24986.215.camel@Joe-Laptop>
	 <AANLkTin+twU1y_C6jfNDXruuoVncEivRO=2=1Jg69Xe=@mail.gmail.com>
	 <20100910090615.GA3644@shadowen.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 02:30:37 -0700
Message-ID: <1284111038.1783.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 10:06 +0100, Andy Whitcroft wrote:
> On Thu, Sep 09, 2010 at 03:24:14PM -0400, Mike Frysinger wrote:
> > On Thu, Sep 9, 2010 at 15:21, Joe Perches wrote:
> > > Add warnings for possible missing const uses of
> > >        static char foo[] = "bar"
> > >    that could be
> > >        static const char foo[] = "bar"
> > > and
> > >        static const char *foo[] = {"bar", "baz"}
> > >    that could be
> > >        static const char * const foo[] = {"bar", "baz"}
> > guess you missed my last e-mail about not bothering checking the
> > static or the contents :)
> > > +               if ($line =~ /\bconst\s+char\s*\*\s*(\w+)\s*\[\s*\]/) {
> > -mike
> Could you elucidate on that comment Mike, perhaps copy those comments
> here.

Mike thinks that any time there is a char array declaration
with a default value like
	[static] char foo[] = "bar";
or
	[static] [const] char *foo[] = {"bar", ...};

checkpatch should issue a "use const" warning.

http://lkml.org/lkml/2010/9/9/205

Maybe.  Maybe not.  I don't like unnecessary warnings for
functional code.  I think it depends on how often those
initialized strings are actually modified post declaration.

If it's a _really_ high percentage, then OK, sure.


