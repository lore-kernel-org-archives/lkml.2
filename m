Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab0IUFbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 01:31:44 -0400
Received: from ist.d-labs.de ([213.239.218.44]:37625 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab0IUFbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 01:31:42 -0400
Date: Tue, 21 Sep 2010 07:31:40 +0200
From: Florian Mickler <florian@mickler.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>
Subject: Re: [RFC PATCH] scripts/get_maintainer.pl: add interactive mode
Message-ID: <20100921073140.32060603@schatten.dmk.lab>
In-Reply-To: <1285029532.25988.82.camel@Joe-Laptop>
References: <1284558207-10223-1-git-send-email-florian@mickler.org>
	<1284563819-11363-1-git-send-email-florian@mickler.org>
	<1285011788.25988.48.camel@Joe-Laptop>
	<20100920235337.6e0ac989@schatten.dmk.lab>
	<1285029532.25988.82.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 17:38:52 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2010-09-20 at 23:53 +0200, Florian Mickler wrote:
> > On Mon, 20 Sep 2010 12:43:08 -0700
> > Joe Perches <joe@perches.com> wrote:
> > > #(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): 
> > I don't think the descriptions on the bottom are that descriptive. Nor
> > can they be. There should probably be just a quick primer like:
> > "([N]+:select) ([N]-:deselect) ([N]?:toggle infos) (Y:approve) (h:help)"
> > and on "h" a long description gets displayed.
> 
> We disagree.  There could be a useful "H" help option.

Oh, we don't disagree that much then. After all, the help option is the
meat of the comment above. Bringing up the alternative syntax for the
prompt was just a suggestion.


> > > Because git history is now not searched by default
> > > when there is a named maintainer, there are no
> > > commit signers.
> > 
> > Don't know if this is intuitive. If there is the possibility to have
> > them shown but not selected, that would be ideal as it relieves the
> > user from pressing extra keys while still having a sane behaviour.
> 
> Use a command line option: --git.
> 
> All command line options apply to create the initial list of
> displayed names.
>
> Or add code to set
> 
> 	$git-fallback = 1 if $interactive;

Are you opposed to that second solution?



> 
> > > 
> > > If the "G" option is entered, you get:
> > > 
> > > #(toggle), A#(author), S#(signed) *(all), ^(none), O(options), Y(approve): g
> > > --------------------------------------------------------------------------------
> > > *  # email/list and role:stats                                        auth sign
> > > *  1 Stephen Hemminger <shemminger@linux-foundation.org>                 1    0
> > >      maintainer:SKGE, SKY2 10/100...,commit_signer:38/69=55%
> > >    2 "David S. Miller" <davem@davemloft.net>                             7   57
> > >      commit_signer:57/69=83%
> > >    3 Mike McCormack <mikem@ring3k.org>                                  16   16
> > >      commit_signer:16/69=23%
> > >    4 Joe Perches <joe@perches.com>                                       4    4
> > >      commit_signer:4/69=6%
> > > *  5 netdev@vger.kernel.org                                           
> > >      open list:SKGE, SKY2 10/100...
> > > *  6 linux-kernel@vger.kernel.org                                     
> > >      open list
> > 
> > I would try to fit reviewed-by in the statistics on the right, because
> > that actually says a bit about the ability and willingness to review
> > code... 
> 
> I think it's not worth it.
> 
> Only about 2% of signatures in git history are reviewed-by:
> 
> Using S shows the signature type.

Yes, that is nice. Did I say, I like the UI over all?

I think showing reviewed-by seperately is good nonetheless, as it might
give an increased awareness to the existence of that line.

In the xserver, no patch is comitted, that doesn't has an explicit
reviewed-by line. That is actually a good thing in my opinion.

> 
> Over the last year:
> $ git log --since=1-year-ago | grep -i "by:.*@" | \
>   cut -f1 -d":" | sort -i | uniq -ci | sort -rn | head -10
>   83413     Signed-off-by
>    6544     Acked-by
>    2022     Reviewed-by
>    1691     Reported-by
>    1065     Tested-by
>     111     Reported-and-tested-by
>      83     Suggested-by
>      31     Requested-by
>      28         Signed-off-by
>      26     Fixed-by


That's just sad. At least there are more Reviewed-By then Reported-By. 
I don't think this actually represents reality of the
development process. 


> > [snip menu parsing code]
> > 
> > That should probably go in an extra function and be slimmed down, like
> > I did in a later version I sent you.
> 
> Maybe.  I think it doesn't matter much though.
> Menu handling code tends to get long.

> > > +sub bool_invert {
> > > +    my ($bool_ref) = @_;
> > > +
> > > +    if ($$bool_ref) {
> > > +	$$bool_ref = 0;
> > > +    } else {
> > > +	$$bool_ref = 1;
> > > +    }
> >  +}
> > 
> > That should just be $$bool_ref = !$$bool_ref (and probably not a
> > function)
> 
> I think it needs to be a function.
> I want a 0 or 1, not "" or 1.

Sorry, I didn't look at the use of that. What about  

$bool = (1 - !!$bool) 

then? (if $bool is always 1 or 0, you can drop the double negation in
front of it)

Cheers,
Flo
