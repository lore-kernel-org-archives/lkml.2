Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1EERGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 13:06:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:4490 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab1EERGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 13:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,321,1301900400"; 
   d="scan'208";a="688696305"
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: Jesper Juhl <jj@chaosbits.net>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
In-Reply-To: <alpine.LNX.2.00.1104240306570.28014@swampdragon.chaosbits.net>
References: <james_p_freyensee@linux.intel.com>
	 <1303515150-1718-4-git-send-email-james_p_freyensee@linux.intel.com>
	 <alpine.LNX.2.00.1104240212390.28014@swampdragon.chaosbits.net>
	 <alpine.LNX.2.00.1104240306570.28014@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 05 May 2011 10:06:03 -0700
Message-ID: <1304615163.8860.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-24 at 03:08 +0200, Jesper Juhl wrote:
> On Sun, 24 Apr 2011, Jesper Juhl wrote:
> 
> > On Fri, 22 Apr 2011, james_p_freyensee@linux.intel.com wrote:
> > 
> ...
> > > +static void pti_tty_cleanup(struct tty_struct *tty)
> > > +{
> > > +	struct pti_tty *pti_tty_data;
> > > +	struct pti_masterchannel *mc;
> > > +
> > > +	pti_tty_data = tty->driver_data;
> > > +
> > > +	if (pti_tty_data != NULL) {
> > > +		mc = pti_tty_data->mc;
> > > +		pti_release_masterchannel(mc);
> > > +		pti_tty_data->mc = NULL;
> > > +	}
> > > +
> > > +	if (pti_tty_data != NULL)
> > > +		kfree(pti_tty_data);
> > > +
> > > +	tty->driver_data = NULL;
> > > +}
> > 
> > How about this instead?
> > 
> > static void pti_tty_cleanup(struct tty_struct *tty)
> > {
> >      if (!tty->driver_data)
> >              return;
> >      pti_release_masterchannel(tty->driver_data->mc);

I like this suggestion.  I'll incorporate this.  

> >      kfree(tty->driver_data);

I'm no means an expert in the kernel, but I assume kfree() is like C
free(), that it's a nop if it receives a NULL value?

> > }
> > 
> I meant to say :
> 
> static void pti_tty_cleanup(struct tty_struct *tty)
> {
>      if (!tty->driver_data)
>              return;
>      pti_release_masterchannel(tty->driver_data->mc);
>      kfree(tty->driver_data);
>      tty->driver_data = NULL
> }   
> 
> 


