Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0D1ToP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:44:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:43797 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756868Ab0D1ToN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:44:13 -0400
Date: Wed, 28 Apr 2010 12:41:00 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH 09/13] drivers/staging/rtl8192su: Hoist assign from if
Message-ID: <20100428194100.GA3602@suse.de>
References: <cover.1269493047.git.joe@perches.com>
 <c45ba099fc8f31f166c4067f2eff609c8eaf422f.1269493047.git.joe@perches.com>
 <20100428182710.GD8509@kroah.com>
 <1272481489.7831.24.camel@Joe-Laptop.home>
 <20100428191116.GA29828@suse.de>
 <1272482446.9188.4.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272482446.9188.4.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 12:20:46PM -0700, Joe Perches wrote:
> On Wed, 2010-04-28 at 12:11 -0700, Greg KH wrote:
> > On Wed, Apr 28, 2010 at 12:04:49PM -0700, Joe Perches wrote:
> > > On Wed, 2010-04-28 at 11:27 -0700, Greg KH wrote:
> > > > On Wed, Mar 24, 2010 at 10:17:03PM -0700, Joe Perches wrote:
> > > > > --- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
> > > > > +++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
> > > > > @@ -1690,7 +1690,8 @@ ieee80211_rx_auth_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
> > > > >  	//IEEE80211DMESG("Rx probe");
> > > > >  	ieee->softmac_stats.rx_auth_rq++;
> > > > >  
> > > > > -	if ((status = auth_rq_parse(skb, dest))!= -1){
> > > > > +	status = auth_rq_parse(skb, dest);
> > > > > +	if (status!= -1) {
> > > > 
> > > > And again.  Did you do this with some tool and not by hand?
> > > []
> > > > Did you not run your patch through checkpatch after creating it and 
> > > > before sending it to me?
> > > 
> > > >From the original 0/13 introduction:
> > > http://lkml.org/lkml/2010/3/25/6
> > > 
> > >         Used scripts/cvt_kernel.style.pl:
> > >         --convert-hoist_assigns_from_if
> > >         and verified visually.
> > >         
> > >         checkpatch errors ignored
> > > 
> > > The script itself is:
> > > http://lkml.org/lkml/2010/3/24/447
> > 
> > And this points out why I hate scripts.
> > 
> > It is _trivial_ to fix up the obvious formatting problem, on the same
> > line that you are modifying, when doing so.
> 
> Define _trivial_ and define obvious.

"I know it when I see it."
