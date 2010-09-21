Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0IUAiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:38:55 -0400
Received: from mail.perches.com ([173.55.12.10]:2168 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab0IUAiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:38:54 -0400
Subject: Re: [RFC PATCH] scripts/get_maintainer.pl: add interactive mode
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>
In-Reply-To: <20100920235337.6e0ac989@schatten.dmk.lab>
References: <1284558207-10223-1-git-send-email-florian@mickler.org>
	 <1284563819-11363-1-git-send-email-florian@mickler.org>
	 <1285011788.25988.48.camel@Joe-Laptop>
	 <20100920235337.6e0ac989@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 17:38:52 -0700
Message-ID: <1285029532.25988.82.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-20 at 23:53 +0200, Florian Mickler wrote:
> On Mon, 20 Sep 2010 12:43:08 -0700
> Joe Perches <joe@perches.com> wrote:
> > #(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): 
> I don't think the descriptions on the bottom are that descriptive. Nor
> can they be. There should probably be just a quick primer like:
> "([N]+:select) ([N]-:deselect) ([N]?:toggle infos) (Y:approve) (h:help)"
> and on "h" a long description gets displayed.

We disagree.  There could be a useful "H" help option.

> > Because git history is now not searched by default
> > when there is a named maintainer, there are no
> > commit signers.
> 
> Don't know if this is intuitive. If there is the possibility to have
> them shown but not selected, that would be ideal as it relieves the
> user from pressing extra keys while still having a sane behaviour.

Use a command line option: --git.

All command line options apply to create the initial list of
displayed names.

Or add code to set

	$git-fallback = 1 if $interactive;

> > 
> > If the "G" option is entered, you get:
> > 
> > #(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): g
> > --------------------------------------------------------------------------------
> > *  # email/list and role:stats                                        auth sign
> > *  1 Stephen Hemminger <shemminger@linux-foundation.org>                 1    0
> >      maintainer:SKGE, SKY2 10/100...,commit_signer:38/69=55%
> >    2 "David S. Miller" <davem@davemloft.net>                             7   57
> >      commit_signer:57/69=83%
> >    3 Mike McCormack <mikem@ring3k.org>                                  16   16
> >      commit_signer:16/69=23%
> >    4 Joe Perches <joe@perches.com>                                       4    4
> >      commit_signer:4/69=6%
> > *  5 netdev@vger.kernel.org                                           
> >      open list:SKGE, SKY2 10/100...
> > *  6 linux-kernel@vger.kernel.org                                     
> >      open list
> 
> I would try to fit reviewed-by in the statistics on the right, because
> that actually says a bit about the ability and willingness to review
> code... 

I think it's not worth it.

Only about 2% of signatures in git history are reviewed-by:

Using S shows the signature type.

Over the last year:
$ git log --since=1-year-ago | grep -i "by:.*@" | \
  cut -f1 -d":" | sort -i | uniq -ci | sort -rn | head -10
  83413     Signed-off-by
   6544     Acked-by
   2022     Reviewed-by
   1691     Reported-by
   1065     Tested-by
    111     Reported-and-tested-by
     83     Suggested-by
     31     Requested-by
     28         Signed-off-by
     26     Fixed-by

> [snip menu parsing code]
> 
> That should probably go in an extra function and be slimmed down, like
> I did in a later version I sent you.

Maybe.  I think it doesn't matter much though.
Menu handling code tends to get long.

> > +sub bool_invert {
> > +    my ($bool_ref) = @_;
> > +
> > +    if ($$bool_ref) {
> > +	$$bool_ref = 0;
> > +    } else {
> > +	$$bool_ref = 1;
> > +    }
>  +}
> 
> That should just be $$bool_ref = !$$bool_ref (and probably not a
> function)

I think it needs to be a function.
I want a 0 or 1, not "" or 1.


