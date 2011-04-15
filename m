Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab1DOR0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:26:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1DOR0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:26:53 -0400
Date: Fri, 15 Apr 2011 10:26:45 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andy Grover <andy.grover@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [74/74] net: fix rds_iovec page count overflow
Message-ID: <20110415172645.GA11669@suse.de>
References: <20110413155406.GA22568@kroah.com>
 <20110413155150.984826556@clark.kroah.org>
 <BANLkTikJDeYPAFeei6DtKPcfvxP1ZeiQaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikJDeYPAFeei6DtKPcfvxP1ZeiQaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 10:10:13AM -0700, Linus Torvalds wrote:
> On Wed, Apr 13, 2011 at 8:51 AM, Greg KH <gregkh@suse.de> wrote:
> > +
> > +               /*
> > +                * nr_pages for one entry is limited to (UINT_MAX>>PAGE_SHIFT)+1,
> > +                * so tot_pages cannot overflow without first going negative.
> > +                */
> > +               if ((int)nr_pages < 0)
> > +                       ret = -EINVAL;
> > +                       goto out;
> >        }
> 
> Yeah, what the heck happened there. That won't work.
> 
> As Paul says, the original was just a "return -EINVAL", and when the
> backport changed it into a "ret = " + "goto out", it really needs a
> couple of braces.
> 
> As it is, the patch is just broken. Think about it.

Ah crap, that's my fault, I did the backport totally wrong here.

I'll fix this up and push an updated version out in a few hours when I
get back from my daughter's earth-day field trip...

thanks,

greg k-h
