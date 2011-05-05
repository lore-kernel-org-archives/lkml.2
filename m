Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1EEWau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 18:30:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:55909 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab1EEWat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 18:30:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,323,1301900400"; 
   d="scan'208";a="742972170"
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Jesper Juhl <jj@chaosbits.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <1304616467.8860.80.camel@localhost>
References: <james_p_freyensee@linux.intel.com>
	 <1303515150-1718-4-git-send-email-james_p_freyensee@linux.intel.com>
	 <alpine.LNX.2.00.1104240212390.28014@swampdragon.chaosbits.net>
	 <1304616467.8860.80.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 05 May 2011 15:30:48 -0700
Message-ID: <1304634648.8860.86.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > static void pti_tty_cleanup(struct tty_struct *tty)
> > {
> >      if (!tty->driver_data)
> >              return;
> >      pti_release_masterchannel(tty->driver_data->mc);
> >      kfree(tty->driver_data);
> > }
> > 
> 
> I think I answered this already; I like the suggestion and will tweak.
> 
> > ...
> > > +static int pti_tty_driver_write(struct tty_struct *tty,
> > > +	const unsigned char *buf, int len)
> > > +{
> > > +	struct pti_masterchannel *mc;
> > > +	struct pti_tty *pti_tty_data;
> > > +
> > > +	pti_tty_data = tty->driver_data;
> > > +	mc = pti_tty_data->mc;
> > > +	pti_write_to_aperture(mc, (u8 *)buf, len);
> > > +
> > > +	return len;
> > > +}
> > 
> > I'd like to suggest this as an alternative:
> > 
> > static int pti_tty_driver_write(struct tty_struct *tty,
> >      const unsigned char *buf, int len)
> > {
> >      pti_write_to_aperture(tty->driver_data->mc, (u8 *)buf, len);
> >      return len;
> > }
> > 
> > 
> 
> If there is no objections I will do it.  What I've coded is the observed
> coding style I've seen, if for no other reason that to shorten up the
> number of '->' used in accessing a member of driver_data.  But this
> doesn't look so bad/ugly.
> 

Ok, so now I remember why this suggestion isn't good and I am going to
have to go back to what I had before.  Some picky compilers do not like
for you to do operations on (void *) variables, other than a beginning
assign statement to a variable with an actual type.    


