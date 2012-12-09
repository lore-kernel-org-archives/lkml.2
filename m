Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab2LIRvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 12:51:16 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57829 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab2LIRvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 12:51:15 -0500
MIME-Version: 1.0
In-Reply-To: <1354991991.3198.7.camel@joe-AO722>
References: <1354988074-2165-1-git-send-email-peter.senna@gmail.com>
	<1354988739.3198.3.camel@joe-AO722>
	<CA+MoWDr0JT0T-0ZUDsqceuXKbjW_mavS9t6HGkFR4dz2XUygWg@mail.gmail.com>
	<1354991991.3198.7.camel@joe-AO722>
Date: Sun, 9 Dec 2012 15:51:14 -0200
Message-ID: <CA+MoWDrKR2SRgo6yPSBOK-D-YuxaXYCUMmTubwL777bd4midaQ@mail.gmail.com>
Subject: Re: [PATCH] scripts/coccinelle/misc/semicolon.cocci: Add unneeded
 semicolon test
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: mmarek@suse.cz, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 8, 2012 at 4:39 PM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2012-12-08 at 16:13 -0200, Peter Senna Tschudin wrote:
>> On Sat, Dec 8, 2012 at 3:45 PM, Joe Perches <joe@perches.com> wrote:
>> > On Sat, 2012-12-08 at 15:34 -0200, Peter Senna Tschudin wrote:
>> >> This semantic patch looks for semicolons that can be removed without
>> >> changing the semantics of the code. The confidence is moderate
>> >> because there are some false positives on cases like:
>> >>
>> >> b/drivers/mmc/host/cb710-mmc.c:589
>> >>                 break;
>> >>         case MMC_POWER_UP:
>> >>         default:
>> >> -               /* ignore */;
>> >>         }
>> > []
>> >> diff --git a/scripts/coccinelle/misc/semicolon.cocci b/scripts/coccinelle/misc/semicolon.cocci
>> > []
>> >> +@r1@
>> >> +statement S;
>> >> +position p1;
>> >> +position p != {r_default.p, r_case.p};
>> >> +identifier label;
>> >> +@@
>> >> +(
>> >> +label:;
>> >> +|
>> >> +S@p1;@p
>> >> +)
>> >> +
>> >
>> > I believe this also fails on this case:
> []
>> > where gcc needs a semicolon after a label before a function exit.
>>
>> No it does not fail. This issue is switch/case specific. See how I've tested:
>
> Thanks Peter, I didn't notice the switch requirement.
>
> In this case, I'd suggest replacement of the
> nominally false positive ; with break;

I agree with you that the best is to replace ; with break; but I
prefer to not change the unneeded semicolon test semantic patch to add
breaks before ;. I can make other semantic patch for that. The point
is that adding break is more than detecting unneeded semicolons, so I
prefer to not mix the two.

But even with the moderate confidence this semantic patch seems to be
useful as new unneeded semicolons are being added to the Kernel.

>
> cheers, Joe
>

Thanks for your help!

Peter


--
Peter
