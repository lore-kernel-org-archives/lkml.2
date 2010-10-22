Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab0JVTYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:24:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759204Ab0JVTYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:24:08 -0400
Date: Fri, 22 Oct 2010 12:23:50 -0700
From: Greg KH <gregkh@suse.de>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Florian Fainelli <florian@openwrt.org>, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, 600155@bugs.debian.org,
        Jason Heeris <jason.heeris@gmail.com>,
        David Miller <davem@davemloft.net>, spamalot@hispeed.ch,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [11/17] r6040: Fix multicast list iteration when hash filter
 is used
Message-ID: <20101022192350.GA10673@suse.de>
References: <20101022184033.486292826@clark.site>
 <4CC1E257.4070704@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC1E257.4070704@fastmail.fm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 08:13:27PM +0100, Jack Stone wrote:
> On 22/10/2010 19:39, Greg KH wrote:
> >  drivers/net/r6040.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- a/drivers/net/r6040.c
> > +++ b/drivers/net/r6040.c
> > @@ -976,6 +976,7 @@ static void r6040_multicast_list(struct
> >  		iowrite16(hash_table[3], ioaddr + MAR3);
> >  	}
> >  	/* Multicast Address 1~4 case */
> > +	dmi = dev->mc_list;
> >  	for (i = 0, dmi; (i < dev->mc_count) && (i < MCAST_MAX); i++) {
> Any reason for the dmi in the above line? As far as I can see it is a
> nop.

Look closer at the for loop please.

thanks,

greg k-h
