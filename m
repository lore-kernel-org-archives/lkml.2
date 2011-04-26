Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1DZTpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:45:13 -0400
Received: from mail.perches.com ([173.55.12.10]:1024 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab1DZTpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:45:12 -0400
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thiago Farina <tfransosi@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1303846642.18763.37.camel@gandalf.stny.rr.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110426190531.GA4556@p183>
	 <1303845468.18763.32.camel@gandalf.stny.rr.com>
	 <20110426192029.GA4686@p183>
	 <BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>
	 <1303846642.18763.37.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 12:45:10 -0700
Message-ID: <1303847110.24299.50.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 15:37 -0400, Steven Rostedt wrote:
> On Tue, 2011-04-26 at 16:21 -0300, Thiago Farina wrote:
> > On Tue, Apr 26, 2011 at 4:20 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > > On Tue, Apr 26, 2011 at 03:17:48PM -0400, Steven Rostedt wrote:
> > >> On Tue, 2011-04-26 at 22:05 +0300, Alexey Dobriyan wrote:
> > >> > On Tue, Apr 26, 2011 at 03:49:49PM -0300, Thiago Farina wrote:
> > >> > > + * streq - Are two strings equal?
> > > The point is that function is trivial, and if someone doesn't
> > > understand it, he should read some Kernighan and Ritchie first.
> Replace it with something like:
> 	* Use this: 	streq(a, b)
> 	* instead of: 	strcmp(a, b) == 0 or !strcmp(a, b)
> 	* This makes the code more readable and less error prone.

I think it's not good to introduce another form.
strcmp is the standard everyone understands.

There are already about 2800 uses of strcmp()==0 and !strcmp

$ grep -rP --include=*.[ch] "\bstrcmp.*==\s*0\b" * | wc -l
1143
$ grep -rP --include=*.[ch] "\!\s*strcmp\s*\(" *  | wc -l
1663

Can you count how many misuses of strcmp have been
corrected?  Do you plan to convert the existing 2800?


