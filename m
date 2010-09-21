Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0IUGMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:12:16 -0400
Received: from mail.perches.com ([173.55.12.10]:2189 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0IUGMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:12:15 -0400
Subject: Re: [RFC PATCH] scripts/get_maintainer.pl: add interactive mode
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>
In-Reply-To: <20100921073140.32060603@schatten.dmk.lab>
References: <1284558207-10223-1-git-send-email-florian@mickler.org>
	 <1284563819-11363-1-git-send-email-florian@mickler.org>
	 <1285011788.25988.48.camel@Joe-Laptop>
	 <20100920235337.6e0ac989@schatten.dmk.lab>
	 <1285029532.25988.82.camel@Joe-Laptop>
	 <20100921073140.32060603@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 23:12:13 -0700
Message-ID: <1285049533.25988.173.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 07:31 +0200, Florian Mickler wrote:
> On Mon, 20 Sep 2010 17:38:52 -0700
> Joe Perches <joe@perches.com> wrote:
> > > > Because git history is now not searched by default
> > > > when there is a named maintainer, there are no
> > > > commit signers.
> > > Don't know if this is intuitive. If there is the possibility to have
> > > them shown but not selected, that would be ideal as it relieves the
> > > user from pressing extra keys while still having a sane behaviour.
> > Use a command line option: --git.
> > All command line options apply to create the initial list of
> > displayed names.
> > Or add code to set
> > 	$git-fallback = 1 if $interactive;
> Are you opposed to that second solution?

Not at all.

I'd prefer to default select all returned entries though.
Maybe add some key to deselect the non-maintainer
git added entries.

> > $ git log --since=1-year-ago | grep -i "by:.*@" | \
> >   cut -f1 -d":" | sort -i | uniq -ci | sort -rn | head -10
> >   83413     Signed-off-by
> >    6544     Acked-by
> >    2022     Reviewed-by
> >    1691     Reported-by
> >    1065     Tested-by
> >     111     Reported-and-tested-by
> >      83     Suggested-by
> >      31     Requested-by
> >      28         Signed-off-by
> >      26     Fixed-by
> That's just sad. At least there are more Reviewed-By then Reported-By. 
> I don't think this actually represents reality of the
> development process. 

I think most all reviewers don't add reviewed-by acks
and most submitters don't collect them.

> > > That should just be $$bool_ref = !$$bool_ref (and probably not a
> > > function)
> > I think it needs to be a function.
> > I want a 0 or 1, not "" or 1.
> Sorry, I didn't look at the use of that. What about  
> $bool = (1 - !!$bool) 
> then? (if $bool is always 1 or 0, you can drop the double negation in
> front of it)

<shrug> Sure.  I don't care which is used.


