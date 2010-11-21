Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab0KUXgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 18:36:12 -0500
Received: from thunk.org ([69.25.196.29]:33584 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768Ab0KUXgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 18:36:11 -0500
Date: Sun, 21 Nov 2010 18:35:44 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Message-ID: <20101121233544.GI23423@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stephen Hemminger <shemminger@vyatta.com>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
	Charles Marker <Charles.Marker@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Kevin Hayes <kevin@atheros.com>,
	Zhifeng Cai <zhifeng.cai@atheros.com>,
	Don Breslin <Don.Breslin@atheros.com>,
	Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <F46C52ED-8DB8-4347-957D-B9D84406D53F@mit.edu>
 <AANLkTinyafwe9MyXhSSe5vxEKnTUeLV0AZDWY_uXsu8f@mail.gmail.com>
 <20101121130236.GE23423@thunk.org>
 <20101121172906.GD3703@kroah.com>
 <AANLkTik6MQjYTCQ4wtyRpOGb94uyUTA+juvX-8UsP95J@mail.gmail.com>
 <20101121203124.1ba8212e@lxorguk.ukuu.org.uk>
 <20101121214407.GH23423@thunk.org>
 <AANLkTinEm1mLAtPZdEp2sHRfKPeV6qYP8f9Dbbr92_JD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinEm1mLAtPZdEp2sHRfKPeV6qYP8f9Dbbr92_JD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 10:47:53PM +0100, Gábor Stefanik wrote:
> 
> By forcing the driver to be GPL, you automatically exclude Windows
> from the list of platforms supported by such a cross-OS driver, as the
> Windows NDIS headers are AFAIK under a GPL-incompatible license, so no
> GPL driver can be written for Windows.

I said GPL "with exceptions".  The exceptions would allow linking with
the necessary glue code (also licensed under GPL "with exceptions")
that allow linkage with legacy operating systems --- including
Windows.

OK, the BSD's won't like it.  Tough.  If someone were to make all of
this code available under those terms, they can either decide to suck
it up and use the code, or use the fact that the hardware dependent
portion of the driver is GPL'ed, which means it won't be supplied in
object-file only form, ala Nvidia, but in source code form, so that if
the BSD's want to use the GPL'ed source code as hardware documentation
so they can write their own docmentation, at least they have the
option/freedom to do so.

That at least would be my recommendation of what anyone doing these
Linux 802.11 compatible stack and shim code for legacy operating
systems do.  If we're going to do the work, we might as well set up
the licensing to force companies to do the right thing --- because if
we don't force companies to do the right thing, in all likelihood
there will be a race to the bottom where they won't.  And even if you
think companies will be altruistic, why not make sure the license is
such that the non-altruistic companies, or the clueless companies are
forced by their lawyers to do the right thing?

Even if Broadcom has reformed (and I don't competely believe it yet),
why should we be completely confident that they won't backslide?

      	      	     	    	   	 - Ted
