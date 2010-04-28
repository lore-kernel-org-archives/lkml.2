Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0D1TUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:20:49 -0400
Received: from mail.perches.com ([173.55.12.10]:1797 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab0D1TUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:20:48 -0400
Subject: Re: [PATCH 09/13] drivers/staging/rtl8192su: Hoist assign from if
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
In-Reply-To: <20100428191116.GA29828@suse.de>
References: <cover.1269493047.git.joe@perches.com>
	 <c45ba099fc8f31f166c4067f2eff609c8eaf422f.1269493047.git.joe@perches.com>
	 <20100428182710.GD8509@kroah.com>
	 <1272481489.7831.24.camel@Joe-Laptop.home> <20100428191116.GA29828@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 12:20:46 -0700
Message-ID: <1272482446.9188.4.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-28 at 12:11 -0700, Greg KH wrote:
> On Wed, Apr 28, 2010 at 12:04:49PM -0700, Joe Perches wrote:
> > On Wed, 2010-04-28 at 11:27 -0700, Greg KH wrote:
> > > On Wed, Mar 24, 2010 at 10:17:03PM -0700, Joe Perches wrote:
> > > > --- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
> > > > +++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
> > > > @@ -1690,7 +1690,8 @@ ieee80211_rx_auth_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
> > > >  	//IEEE80211DMESG("Rx probe");
> > > >  	ieee->softmac_stats.rx_auth_rq++;
> > > >  
> > > > -	if ((status = auth_rq_parse(skb, dest))!= -1){
> > > > +	status = auth_rq_parse(skb, dest);
> > > > +	if (status!= -1) {
> > > 
> > > And again.  Did you do this with some tool and not by hand?
> > []
> > > Did you not run your patch through checkpatch after creating it and 
> > > before sending it to me?
> > 
> > >From the original 0/13 introduction:
> > http://lkml.org/lkml/2010/3/25/6
> > 
> >         Used scripts/cvt_kernel.style.pl:
> >         --convert-hoist_assigns_from_if
> >         and verified visually.
> >         
> >         checkpatch errors ignored
> > 
> > The script itself is:
> > http://lkml.org/lkml/2010/3/24/447
> 
> And this points out why I hate scripts.
> 
> It is _trivial_ to fix up the obvious formatting problem, on the same
> line that you are modifying, when doing so.

Define _trivial_ and define obvious.

Here you've multiple situations of initial line spacing
not using tabs, odd use of parentheses in the original
style, compressed logical tests or assigns, etc.

All trivially fixable, but not necessarily correct to do
in a single pass.

If you do them in a single pass, you run into your "do too
much in a single patch" argument.

cheers, Joe

