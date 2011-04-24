Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab1DXBO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:14:59 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21889 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab1DXBO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:14:58 -0400
Date: Sun, 24 Apr 2011 03:08:42 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: james_p_freyensee@linux.intel.com
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
In-Reply-To: <alpine.LNX.2.00.1104240212390.28014@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1104240306570.28014@swampdragon.chaosbits.net>
References: <james_p_freyensee@linux.intel.com> <1303515150-1718-4-git-send-email-james_p_freyensee@linux.intel.com> <alpine.LNX.2.00.1104240212390.28014@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Apr 2011, Jesper Juhl wrote:

> On Fri, 22 Apr 2011, james_p_freyensee@linux.intel.com wrote:
> 
...
> > +static void pti_tty_cleanup(struct tty_struct *tty)
> > +{
> > +	struct pti_tty *pti_tty_data;
> > +	struct pti_masterchannel *mc;
> > +
> > +	pti_tty_data = tty->driver_data;
> > +
> > +	if (pti_tty_data != NULL) {
> > +		mc = pti_tty_data->mc;
> > +		pti_release_masterchannel(mc);
> > +		pti_tty_data->mc = NULL;
> > +	}
> > +
> > +	if (pti_tty_data != NULL)
> > +		kfree(pti_tty_data);
> > +
> > +	tty->driver_data = NULL;
> > +}
> 
> How about this instead?
> 
> static void pti_tty_cleanup(struct tty_struct *tty)
> {
>      if (!tty->driver_data)
>              return;
>      pti_release_masterchannel(tty->driver_data->mc);
>      kfree(tty->driver_data);
> }
> 
I meant to say :

static void pti_tty_cleanup(struct tty_struct *tty)
{
     if (!tty->driver_data)
             return;
     pti_release_masterchannel(tty->driver_data->mc);
     kfree(tty->driver_data);
     tty->driver_data = NULL
}   


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

