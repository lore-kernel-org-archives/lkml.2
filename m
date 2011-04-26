Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1DZUHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:07:08 -0400
Received: from mail.perches.com ([173.55.12.10]:1027 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1DZUHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:07:06 -0400
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thiago Farina <tfransosi@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1303847902.18763.38.camel@gandalf.stny.rr.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110426190531.GA4556@p183>
	 <1303845468.18763.32.camel@gandalf.stny.rr.com>
	 <20110426192029.GA4686@p183>
	 <BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>
	 <1303846642.18763.37.camel@gandalf.stny.rr.com>
	 <1303847110.24299.50.camel@Joe-Laptop>
	 <BANLkTimf44AgMAViHrSEz78ifHUYb8ji6g@mail.gmail.com>
	 <1303847902.18763.38.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 13:06:53 -0700
Message-ID: <1303848413.24299.57.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 15:58 -0400, Steven Rostedt wrote:
> On Tue, 2011-04-26 at 16:47 -0300, Thiago Farina wrote:
> > > $ grep -rP --include=*.[ch] "\bstrcmp.*==\s*0\b" * | wc -l
> > > 1143
> > > $ grep -rP --include=*.[ch] "\!\s*strcmp\s*\(" *  | wc -l
> > > 1663
> > > Can you count how many misuses of strcmp have been
> > > corrected?
> > > Do you plan to convert the existing 2800?
> > I'd work on this without any problem.
> Nothing a perl script can't do either.

That's not a real problem.

my $match_balanced_parentheses = qr/(\((?:[^\(\)]++|(?-1))*\))/;
s/\bstrcmp\s*${match_balanced_parentheses}\s*==\s*0\b/streq$1/g;
s/\!\s*strcmp\s*\(/streq\(/g;

And the other strcmp uses too?

