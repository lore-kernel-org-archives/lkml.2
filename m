Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1GJWfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 18:35:30 -0400
Received: from mail.perches.com ([173.55.12.10]:3823 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1GJWf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 18:35:29 -0400
Subject: Re: [PATCH] scripts/checkpatch.pl: added test for repeated lines
From: Joe Perches <joe@perches.com>
To: Edwin van Vliet <edwin@minian.org>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
In-Reply-To: <4E1A0A2F.6050800@minian.org>
References: <1310321889-25943-1-git-send-email-edwin@cheatah.nl>
	 <1310323798.3848.48.camel@Joe-Laptop>  <4E1A0A2F.6050800@minian.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 15:35:28 -0700
Message-ID: <1310337328.2446.8.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-10 at 22:23 +0200, Edwin van Vliet wrote:
> On 10-7-2011 20:49, Joe Perches wrote:
> > On Sun, 2011-07-10 at 20:18 +0200, Edwin van Vliet wrote:
> >> Repeated lines may indicate a bug or code that needs clarification. If the
> >> repeated line is intentional, an extra comment may be helpful for reviewers
> >> since the repeated pattern is likely to draw attention.
> > []
> >> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > []
> >> @@ -1479,6 +1479,11 @@ sub process {
> >> +# check for repeated lines which may indicate bugs or lack of clarity
> >> +		if ($rawline eq $prevrawline) {
> >> +			WARN("repeated line\n" . $herecurr);
> >> +		}
> >> +
> > Interest concept, but I think it needs to check for
> > comment lines and blank lines and such.
> > Also, there are uses of appropriate multiple close braces
> > on consecutive lines like:
> > 	switch (foo) {
> > 	case bar: {
> > 		etc...
> > 	}
> > 	}
[]
> You might be correct about empty lines and comment lines, but there are
> actually very few reasons to have a repeated line.
[]
> Repeated lines draw (my) attention, and are likely to confuse.

I don't disagree, I just think your patch needs to handle
some obvious exceptions.

> Do you reckon this test would lead to programmers trying to "fool" the
> test and actually insert extra tabs to work around it?

No.

> If the final goal of the checkpatch.pl script is for the entire kernel
> source code to not generate any warnings at all,

It's not.

> I understand your concerns and agree this might need a little testing

and expanding and improving.

[]
> Sure, double #endif's and closing brackets will cause a warning, quite a
> number of false positives are inevitable.

Not if your patch handles them appropriately.
Maybe use both CHK and WARN.

> But it will hopefully help to
> prevent or spot errors too, and it might lead to better documentation of
> certain routines as well.

True.  But don't expect me to ack or add a sign-off to
a patch that has obvious defects or doesn't do the
thing it purports to do well.

cheers, Joe

