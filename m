Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965490Ab2LHSjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 13:39:53 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48067 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965440Ab2LHSjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 13:39:52 -0500
Message-ID: <1354991991.3198.7.camel@joe-AO722>
Subject: Re: [PATCH] scripts/coccinelle/misc/semicolon.cocci: Add unneeded
 semicolon test
From: Joe Perches <joe@perches.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: mmarek@suse.cz, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Date: Sat, 08 Dec 2012 10:39:51 -0800
In-Reply-To: <CA+MoWDr0JT0T-0ZUDsqceuXKbjW_mavS9t6HGkFR4dz2XUygWg@mail.gmail.com>
References: <1354988074-2165-1-git-send-email-peter.senna@gmail.com>
	 <1354988739.3198.3.camel@joe-AO722>
	 <CA+MoWDr0JT0T-0ZUDsqceuXKbjW_mavS9t6HGkFR4dz2XUygWg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-08 at 16:13 -0200, Peter Senna Tschudin wrote:
> On Sat, Dec 8, 2012 at 3:45 PM, Joe Perches <joe@perches.com> wrote:
> > On Sat, 2012-12-08 at 15:34 -0200, Peter Senna Tschudin wrote:
> >> This semantic patch looks for semicolons that can be removed without
> >> changing the semantics of the code. The confidence is moderate
> >> because there are some false positives on cases like:
> >>
> >> b/drivers/mmc/host/cb710-mmc.c:589
> >>                 break;
> >>         case MMC_POWER_UP:
> >>         default:
> >> -               /* ignore */;
> >>         }
> > []
> >> diff --git a/scripts/coccinelle/misc/semicolon.cocci b/scripts/coccinelle/misc/semicolon.cocci
> > []
> >> +@r1@
> >> +statement S;
> >> +position p1;
> >> +position p != {r_default.p, r_case.p};
> >> +identifier label;
> >> +@@
> >> +(
> >> +label:;
> >> +|
> >> +S@p1;@p
> >> +)
> >> +
> >
> > I believe this also fails on this case:
[]
> > where gcc needs a semicolon after a label before a function exit.
> 
> No it does not fail. This issue is switch/case specific. See how I've tested:

Thanks Peter, I didn't notice the switch requirement.

In this case, I'd suggest replacement of the
nominally false positive ; with break;

cheers, Joe

