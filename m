Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab0HJMjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:39:47 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:37686 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab0HJMjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:39:44 -0400
Subject: Re: [PATCHv4] fixed resource leak in scripts/mod/modpost.c
From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
To: ext Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Trevor Keith <tsrk@tsrk.net>, Rusty Russell <rusty@rustcorp.com.au>,
        ext Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTinCzXCAfrQ46N-AQAUVS_N4kT=p58b6GZR1AL47@mail.gmail.com>
References: <1281010151.2063.8.camel@alex-desktop>
	 <AANLkTi=YessPd6cHhLdveyrSq_TcY1Vx1LxpCNLthEJG@mail.gmail.com>
	 <1281437552.2063.431.camel@alex-desktop>
	 <AANLkTi=UfzGay5XQKMpPCZTSO5SJ1jDknqwayhrEZJO0@mail.gmail.com>
	 <1281441808.2063.498.camel@alex-desktop>
	 <AANLkTinCzXCAfrQ46N-AQAUVS_N4kT=p58b6GZR1AL47@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 15:40:28 +0300
Message-ID: <1281444028.2063.542.camel@alex-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 14:21 +0200, ext Andy Shevchenko wrote:
> On Tue, Aug 10, 2010 at 3:03 PM, Alexey Fomenko
> <ext-alexey.fomenko@nokia.com> wrote:
> > From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
> >
> > sec2annotation() returns malloc'ed buffer directly to printf as an
> > argument. Patch lets free this buffer after printing. Preventing ops
> > while freeing the buffer by changing return const str to return
> > strdup empty line.
> >
> > Signed-off-by: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
> 
> > @@ -1283,11 +1301,15 @@
> >                "uses functionality in the exit path.\n"
> >                "The fix is often to remove the %sannotation of\n"
> >                "%s%s so it may be used outside an exit section.\n",
> > -               from, sec2annotation(fromsec), fromsym, from_p,
> > -               to, sec2annotation(tosec), tosym, to_p,
> > -               sec2annotation(tosec), tosym, to_p);
> > +               from, prl_from, fromsym, from_p,
> > +               to, prl_to, tosym, to_p,
> > +               ptl_to, tosym, to_p);
> Did you ever compile this code?
> It looks typo here.
Ever - yes, last one - no, was in a hurry. Shouldn't have been.
I'll fix it.

> 
> > +               free(prl_from);
> > +               free(prl_to);
> >                break;
> >        case ANY_EXIT_TO_ANY_INIT:
> > +               prl_from = sec2annotation(fromsec);
> > +               prl_to = sec2annotation(tosec);
> >                fprintf(stderr,
> >                "The %s %s%s%s references\n"
> >                "a %s %s%s%s.\n"
> 


